FROM centos:7

# Installing required packages
RUN yum update -y && \
    yum install wget curl \
    httpd httpd-tools -y && \
    yum clean all

# Install EPEL Repo
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Install PHP
RUN yum --enablerepo=remi-php73 -y install php php-bcmath php-cli php-common php-gd php-intl php-ldap php-mbstring \
    php-mysqlnd php-pear php-soap php-xml php-xmlrpc php-zip

# Update Apache Configuration
RUN sed -E -i -e '/<Directory "\/var\/www\/html">/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
RUN sed -E -i -e 's/DirectoryIndex (.*)$/DirectoryIndex index.php \1/g' /etc/httpd/conf/httpd.conf

# Version
ENV MEDIAWIKI_MAJOR_VERSION 1.34
ENV MEDIAWIKI_BRANCH REL1_34
ENV MEDIAWIKI_VERSION 1.34.2
ENV MEDIAWIKI_SHA512 ea95b46b746c0c180b5cb3b8a2263a2f94207eadbb1638c2113e97b1503c3f0a4d82a2107ce4cabca4790512b81564bda49defe30ac0fdb9bddf3230d6201f8b

# MediaWiki setup
RUN set -eux; \
    mkdir /tmp/mediawiki; \
    cd /tmp; \
    curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o mediawiki.tar.gz; \
    echo "${MEDIAWIKI_SHA512} *mediawiki.tar.gz" | sha512sum -c -; \
    cd \tmp\mediawiki; \
    tar -x --strip-components=1 -f \tmp\mediawiki.tar.gz; \
    mv \tmp\mediawiki \var\www; \
    rm mediawiki.tar.gz;

EXPOSE 80

# Start Apache
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]