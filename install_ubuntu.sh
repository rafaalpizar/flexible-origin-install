#!/bin/bash

cd ~

# Install software
apt update
apt install -y curl emacs git libapache2-mod-wsgi-py3 python3 python3-pip python3-venv apache2 libapache2-mod-security2

# Install and configure Flexible Origin code
cd /srv
git clone https://github.com/rafaalpizar/flexible-origin.git /srv/flexible-origin
python3 -m venv /srv/flexible-origin_venv
source /srv/flexible-origin_venv/bin/activate
pip3 install flask
deactivate

# Configure Apache
curl -o /etc/apache2/sites-available/flexible-origin.conf \
     https://raw.githubusercontent.com/rafaalpizar/flexible-origin-install/master/apache/flexible-origin.conf

a2dissite *
a2ensite flexible-origin.conf
a2enmod wsgi ssl security2

# Create self sign certificates
mkdir /srv/tls_certs/
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /srv/tls_certs/privkey.pem -out /srv/tls_certs/cert.pem \
	-subj "/C=US/ST=Oregon/L=Bend/O=xap/OU=devel/CN=flexorigin/emailAddress=fo@test.net"

# Restart apache
systemctl restart apache2

# Restart apache every hour
curl -o /etc/cron.hourly/flexible-origin_restart \
     https://raw.githubusercontent.com/rafaalpizar/flexible-origin-install/master/cron/flexible-origin_restart
chmod u+x /etc/cron.hourly/flexible-origin_restart
