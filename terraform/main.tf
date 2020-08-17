data "google_client_config" "provider" {}

resource "google_container_cluster" "mediawiki" {
  name               = var.name
  location           = var.zone
  initial_node_count = var.node_count

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    tags = ["default-allow-mediawiki"]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

provider "kubernetes" {
    load_config_file = false

    host  = "https://${data.google_container_cluster.mediawiki.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
        data.google_container_cluster.mediawiki.master_auth[0].cluster_ca_certificate,
    )
}

resource "google_compute_firewall" "default" {
  name    = "mediawiki-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["30007","30306"]
  }
  source_ranges   = ["0.0.0.0/0"]
  target_tags = ["default-allow-mediawiki"]
}

resource "google_compute_instance" "mediawiki" {
  name         = var.name
  machine_type = var.machinetype
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  connection {
    type  = "ssh"
    host  = "${google_compute_instance.mediawiki.network_interface.0.access_config.0.nat_ip}"
    user  = var.ssh_user
    private_key = file("ssh_key")
  }

  provisioner "file" {
    source      = "credentials.json"
    destination = "/tmp/credentials.json"
  }

  provisioner "file" {
    source      = "setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sh /tmp/setup.sh ${var.name} ${var.zone} ${var.project}"
    ]
  }

}
