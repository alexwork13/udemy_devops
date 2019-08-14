#!/bin/bash
yum -y update
sudo amazon-linux-extras install -y nginx1.12
cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Test</title>
</head>
<body bgcolor="gray">
<h2><font color=blue>Hello from ${number}, ${name}</font> </h2>
</body>
</html>
EOF
sudo systemctl start nginx
#sudo aws s3 sync s3://test-palach-devops13/web1/ /usr/share/nginx/html
sudo service nginx restart