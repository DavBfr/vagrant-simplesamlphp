#!/bin/bash

####################
# Prerequisites

apt-get update -y
apt-get install -y git subversion curl htop

####################
# apache2 server
apt-get install -y apache2
apt-get install -y apache2-doc apache2-suexec-pristine apache2-suexec-custom apache2-utils openssl-blacklist
apt-get install -y php-pear libmcrypt-dev mcrypt
apt-get install -y php5 libapache2-mod-php5 php5-mcrypt
apt-get install -y php5-common php5-cli php5-curl php5-gmp php5-ldap
apt-get install -y libapache2-mod-gnutls

#sudo apt-get install -y mysql-server libapache2-mod-auth-mysql php5-mysql

a2enmod gnutls

/etc/init.d/apache2 restart


####################
# SimpleSaml

cd /var
git clone https://github.com/simplesamlphp/simplesamlphp.git
cd /var/simplesamlphp
mkdir -p config && cp -r config-templates/* config/
mkdir -p metadata && cp -r metadata-templates/* metadata/
ln -sf /vagrant/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf
for file in /vagrant/etc/simplesamlphp/config/*; do
	ln -sf $file /var/simplesamlphp/config/$(basename $file)
done
for file in /vagrant/etc/simplesamlphp/metadata/*; do
	ln -sf $file /var/simplesamlphp/metadata/$(basename $file)
done
touch /var/simplesamlphp/modules/exampleauth/enable

####################
# SSL

cd /var/simplesamlphp
mkdir -p cert
openssl req -x509 -batch -nodes -newkey rsa:2048 -keyout cert/saml.pem -out cert/saml.crt


####################
# Composer
echo "extension=mcrypt.so" >> /etc/php5/cli/php.ini
echo "extension=mcrypt.so" >>  /etc/php5/mods-available/mcrypt.ini
php5enmod mcrypt

curl -sS https://getcomposer.org/installer | php
sudo php composer.phar install

/etc/init.d/apache2 restart

echo ""
echo "==============================="
echo "use this url as idp:"
echo "   http://<host ip>:50080/simplesaml/saml2/idp/SSOService.php?spentityid=ovd"
openssl x509 -noout -fingerprint -in /var/simplesamlphp/cert/saml.crt
echo "modify etc/simplesamlphp/metadata/saml20-sp-remote.php with the right ip address:"
echo "   'AssertionConsumerService' => 'http://<web access>/ovd/auth/saml2/acs.php'"
echo "==============================="
echo ""
