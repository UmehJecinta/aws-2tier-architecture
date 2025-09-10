This project provisions a highly available, scalable and secure 2-tier architecture on AWS using Terraform.

What’s Included

 •	Networking: VPC, public and private subnets, route tables, Internet Gateway, NAT Gateway

 •	Compute: EC2 instances via Launch Templates and Auto Scaling Groups (ASGs)

 •	Load Balancing:

 •	Public-facing Application Load Balancer (ALB) for the web tier

 •	Internal Application Load Balancer (ALB) for the application tier

 •  Security: Security groups for ALBs, web servers, and application servers

 •  User Data: Bootstraps web servers with nginx and a simple website

How to Deploy

Run the following commands inside your Terraform project folder:

 •  terraform init      # Initialize Terraform 
 •  terraform plan      # Preview the changes
 •	terraform apply     #Apply the configuration
 
Access the Application

After terraform apply, Terraform will output the public ALB DNS name.

Copy the DNS name into your browser.

You should see:

Welcome to My 2-Tier AWS Architecture
This website is deployed using Terraform, EC2 Auto Scaling, and an Application Load Balancer.

Clean Up

 When you’re done testing, run:

 •  terraform destroy     #To Clean up resources when you’re done testing to avoid charges
