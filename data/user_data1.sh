#!/bin/bash
yum -y update
sudo amazon-linux-extras install -y nginx1.12
sudo systemctl start nginx
sudo aws s3 sync s3://test-palach-devops13/web1/ /usr/share/nginx/html
sudo service nginx restart