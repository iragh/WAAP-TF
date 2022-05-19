#!/bin/bash

# Update and download Nginx
until sudo apt-get update && sudo apt-get -y install nginx;do
    sleep 1
done

# Update and download docker
until sudo  apt-get -y install docker.io;do
    sleep 1
done

# Pull Juice Repository
until sudo docker pull bkimminich/juice-shop;do
    sleep 1
done

# Start Docker
sudo service nginx stop
sudo docker run --rm -d -p 3000:3000 bkimminich/juice-shop:latest

# Gather IP address

ip_address=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Modify Nginx Config to allow access to Juice Store
sudo touch /etc/nginx/conf.d/juice.conf

sudo chmod a+w /etc/nginx/conf.d/juice.conf

sudo cat <<EOT >> /etc/nginx/conf.d/juice.conf
server {
  listen 80;
  listen [::]:80;

  server_name $ip_address;

  location / {
      proxy_pass http://localhost:3000/;
  }
}
EOT

sudo service nginx restart
sleep 2
sudo nginx -s reload

# Download the CPnanoAgent - vm Azure 19mai22v1
until curl \
    --output /home/$name/cp-nano-egg \
    --url https://sc1.checkpoint.com/nanoegg/cp-nano-egg ; do
    sleep 1
done

# Install CP Nano Agent - com token integrado em trf-02
sudo chmod 755 /home/$name/cp-nano-egg
sleep 1
sudo /home/$name/cp-nano-egg --install --ignore accessControl --token $token 
