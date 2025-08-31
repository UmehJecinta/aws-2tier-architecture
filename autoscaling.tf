# create a launch templete for public instances
resource  "aws_launch_template"  "public_launch_template" {
  name = "public_launch_template"

  image_id = "ami-0df8c184d5f6ae949"
  instance_type = "t2.micro"

  network_interfaces {
     associate_public_ip_address = true
     security_groups = [aws_security_group.alb_sg.id]
  }

  user_data = filebase64("userdata.sh")

  tag_specifications {
     resource_type = "instance"
     tags = {
        name = "public_launch_template"
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

  health_check_type = "EC2"

}


# create a launch template for private instances
resource  "aws_launch_template"  "private_launch_template" {
  name = "private_launch_template"

  image_id = "ami-0df8c184d5f6ae949"
  instance_type = "t2.micro"

  network_interfaces {
     associate_public_ip_address = false
     security_groups = [aws_security_group.alb_sg2.id]
  }

  # ommittting user data for the private instances

  tag_specifications {
     resource_type = "instance"
     tags = {
        name = "private_launch_template"
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

  health_check_type = "EC2"

}