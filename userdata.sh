#!/bin/bash
# User data for new EC2 instances
sudo apt-get update -y

sudo apt-get install -y apache2

sudo systemctl start apache2

sudo systemctl enable apache2

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>My Simple Website</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
    h1 { color: #2E86C1; }
    p { color: #555; }
  </style>
</head>
<body>
  <h1>Welcome to My 2-Tier AWS Architecture</h1>
  <p>This website is deployed using Terraform, EC2 Auto Scaling, and an Application Load Balancer.</p>
</body>
</html>
EOF
