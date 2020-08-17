# Mediawiki on Kubernetes
This automation provisions a kubernetes cluster and deployes the Mediawiki applicaiton along with Mariadb.

## Setup Instructions
Follow the below set of instructions to setup Mediawiki application.

### Pre-Requisites
Centos-7 machine is used for this setup.
1. Install `GIT`
```sh
sudo yum install git -y
```
2. Install `Terraform`
```sh
sudo wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip
sudo unzip ./terraform_0.13.0_linux_amd64.zip –d /usr/local/bin
```

### Process to run the code
1. Clone this repo and switch to terraform directory using below commands
```sh
git clone https://github.com/Pavan-Boddu/tw-mediawiki.git
cd tw-mediawiki/terraform
```
2. Update the `terraform.tfvars` with appropriate values
3. Update the credentials.json with corresponding service account json key value.
4. Copy the private key value of `~/.ssh/id_rsa` file or corresponding private key value to `credentials.json` to ssh to the cloud instance.
5. Apply the terraform using below commands
```sh
terraform init
terraform plan
terraform apply
```
6. On a successfull execution, the terminal output contains the external IP and the Mediawiki application can be accessed at `http://<External_IP>:30007`. The database details like root credentials and database name can be found under `tw-mediawiki/kubernetes/helm/tw-mediawiki/values.yaml`