#!/bin/bash
# User Data for EC2 Instances (Ubuntu with Nginx)
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Nginx
sudo apt-get install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Create a simple index.html
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>My Simple Website</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
    h1 { color: #27AE60; }
    p { color: #555; }
  </style>
</head>
<body>
  <h1>Welcome to My 2-Tier AWS Architecture</h1>
  <p>This website is deployed using Terraform, EC2 Auto Scaling, and an Application Load Balancer with Nginx.</p>
</body>
</html>
EOF

