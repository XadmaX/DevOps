# Upgrade installed packages
```
sudo apt update && sudo apt upgrade -y
```
# Install Java
```
sudo apt install openjdk-11-jdk -y
```
# Install Apache HTTP
```
sudo apt install apache2 -y
```
# Add key for Jenkins package
```
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null
```
# Add repository for installation
```
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
```
# Update the package index
```
sudo apt-get update
```
# Install jenkins
```
sudo apt-get install jenkins
```
# Setup ssl 
```
sudo mkdir /etc/apache2/ssl
```
# Generate self signed ssl certificate 
```
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt
```
# Setup Apache
```
sudo bash -c 'cat > /etc/apache2/sites-available/000-default.conf << EOF
<VirtualHost *:80>
   ServerName localhost
   Redirect / https://localhost/
</VirtualHost>

<VirtualHost *:443>
   SSLEngine on
   SSLCertificateFile /etc/apache2/ssl/apache.crt
   SSLCertificateKeyFile /etc/apache2/ssl/apache.key

   ProxyRequests Off
   ProxyPreserveHost On
   ProxyPass / http://localhost:8080/
   ProxyPassReverse / http://localhost:8080/
</VirtualHost>
EOF'
```
# Setup proxy
```
sudo bash -c 'cat > /etc/apache2/mods-available/proxy.conf << EOF
<IfModule mod_proxy.c>
ProxyPass         /  http://localhost:8080/ nocanon
ProxyPassReverse  /  http://localhost:8080/
ProxyRequests     Off
AllowEncodedSlashes NoDecode

<Proxy http://localhost:8080/*>
  Order deny,allow
  Allow from all
</Proxy>
</IfModule>
EOF'
```
# Install Apache mods
```
sudo a2enmod ssl
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod rewrite
sudo a2enmod headers
```
# Change HTTP_HOST
```
sudo vim /etc/default/jenkins

HTTP_HOST=127.0.0.1
JENKINS_ARGS="--webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT --httpListenAddress=$HTTP_HOST"
```
# Run a shell from Jenkins using sudo
```
sudo vim /etc/sudoers
```
add line:
```
jenkins ALL=(ALL) NOPASSWD: ALL
```
# Restart both services
```
sudo systemctl restart apache2
sudo systemctl restart jenkins
```
