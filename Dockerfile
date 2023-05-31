FROM httpd

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update; \
apt install -y curl git libapache2-mod-wsgi-py3 python3 python3-pip python3-venv libapache2-mod-security2; \
mkdir -p /etc/cron.hourly; \
mkdir -p /srv/tls_certs/; \
mkdir -p /var/run/apache2; \ 
mkdir -p /var/log/apache2; \
mkdir -p /var/www/html; \
chgrp www-data /var/run/apache2; \
chgrp www-data /var/log/apache2; \
git clone -b master --depth 1 https://github.com/rafaalpizar/flexible-origin.git /srv/flexible-origin; \
python3 -m venv /srv/flexible-origin_venv; \
sh source /srv/flexible-origin_venv/bin/activate; \
pip3 install flask; \
deactivate; \
touch /srv/flexible-origin/static/fo.log; \
chgrp www-data /srv/flexible-origin/static/fo.log; \
chmod g+w /srv/flexible-origin/static/fo.log; \
curl -o /usr/local/apache2/conf/flexible-origin.conf \
     https://raw.githubusercontent.com/rafaalpizar/flexible-origin-install/master/apache/flexible-origin-docker.conf; \
sed -i s/"#LoadModule ssl_module"/"LoadModule ssl_module"/ /usr/local/apache2/conf/httpd.conf; \
echo "Include /etc/apache2/mods-available/wsgi.load" >> /usr/local/apache2/conf/httpd.conf; \
echo "Include /etc/apache2/mods-available/wsgi.conf" >> /usr/local/apache2/conf/httpd.conf; \
echo "Include /etc/apache2/mods-available/security2.load" >> /usr/local/apache2/conf/httpd.conf; \
echo "Include /etc/apache2/mods-available/security2.conf" >> /usr/local/apache2/conf/httpd.conf; \
echo "Include conf/flexible-origin.conf" >> /usr/local/apache2/conf/httpd.conf; \
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /srv/tls_certs/privkey.pem -out /srv/tls_certs/cert.pem \
	-subj "/C=US/ST=Oregon/L=Bend/O=xap/OU=devel/CN=flexorigin/emailAddress=fo@test.net"; \
curl -o /etc/cron.hourly/flexible-origin_restart \
     https://raw.githubusercontent.com/rafaalpizar/flexible-origin-install/master/cron/flexible-origin_restart; \
chmod u+x /etc/cron.hourly/flexible-origin_restart
