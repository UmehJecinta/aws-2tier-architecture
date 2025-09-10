# get the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# create key pair for EC2 instances
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "aws-2tier-key"
  public_key = file("~/.ssh/id_rsa.pub")  # Make sure this file exists or update path
}

# create a launch template for public instances
resource  "aws_launch_template"  "public_launch_template" {
  name = "public_launch_template"

  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.ec2_key_pair.key_name

  network_interfaces {
     associate_public_ip_address = true
     security_groups = [aws_security_group.webserver_sg.id]
  }

  user_data = filebase64("userdata.sh")

  tag_specifications {
     resource_type = "instance"
     tags = {
        Name = "public_launch_template"
     }
  }
}

# create autoscaling group
resource "aws_autoscaling_group" "public_asg" {
    max_size = 4
    min_size = 2
    desired_capacity = 2
    name = "webserver_asg"
    target_group_arns = [aws_lb_target_group.alb_tg.arn]
    vpc_zone_identifier = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]

    launch_template {
      id = aws_launch_template.public_launch_template.id
      version = "$Latest"
      
  }

  health_check_type = "ELB"
  health_check_grace_period = 300

}


# create a launch template for private instances
resource  "aws_launch_template"  "private_launch_template" {
  name = "private_launch_template"

  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.ec2_key_pair.key_name

  network_interfaces {
     associate_public_ip_address = false
     security_groups = [aws_security_group.appserver_sg.id]
  }

  # omitting user data for the private instances

  tag_specifications {
     resource_type = "instance"
     tags = {
        Name = "private_launch_template"
     }
  }
}

# create autoscaling group
resource "aws_autoscaling_group" "private_asg" {
    max_size = 4
    min_size = 2
    desired_capacity = 2
    name = "appserver_asg"
    target_group_arns = [aws_lb_target_group.alb_tg2.arn]
    vpc_zone_identifier = [aws_subnet.private_subnet1.id , aws_subnet.private_subnet2.id]

    launch_template {
      id = aws_launch_template.private_launch_template.id
      version = "$Latest"
      
  }

  health_check_type = "ELB"
  health_check_grace_period = 300

}
