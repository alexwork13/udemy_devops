#!/bin/bash
yum -y update
sudo amazon-linux-extras install -y nginx1.12
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
cat <<EOF > /usr/share/nginx/html/index.html
<html>
<body bgcolor="black">
<h2><font color="gold">Build by Power of Terraform <font color="red"> v0.12</font></h2><br><p>
<font color="green">Server PrivateIP: <font color="aqua">$myip<br><br>
<font color="magenta">
<b>Version 4.0</b>
</body>
</html>
EOF
sudo systemctl start nginx
#sudo aws s3 sync s3://test-palach-devops13/web1/ /usr/share/nginx/html
sudo service nginx restart





