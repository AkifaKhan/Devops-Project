# Launch Template for Ubuntu
resource "aws_launch_template" "ubuntu_lt" {
  name_prefix   = "ubuntu-lt-"
  image_id      = var.ubuntu_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = filebase64("${path.module}/userdata/ubuntu_userdata.sh")

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "autoscaling-ubuntu"
    }
  }
}

# Launch Template for Amazon Linux 2
resource "aws_launch_template" "al2_lt" {
  name_prefix   = "al2-lt-"
  image_id      = var.al2_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = filebase64("${path.module}/userdata/al2_userdata.sh")

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "autoscaling-al2"
    }
  }
}

# Launch Template for Amazon Linux 2023
resource "aws_launch_template" "al2023_lt" {
  name_prefix   = "al2023-lt-"
  image_id      = var.al2023_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = filebase64("${path.module}/userdata/al2023_userdata.sh")

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "autoscaling-al2023"
    }
  }
}

# Auto Scaling Group for Ubuntu
resource "aws_autoscaling_group" "ubuntu_asg" {
  name                      = "ubuntu-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_type         = "ELB"                # Using ALB health checks
  health_check_grace_period = 600                  # 5 mins grace
  launch_template {
    id      = aws_launch_template.ubuntu_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [aws_subnet.public_1.id]

  target_group_arns         = [aws_lb_target_group.tg_ubuntu.arn]

  tag {
    key                 = "Name"
    value               = "ubuntu-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group for Amazon Linux 2
resource "aws_autoscaling_group" "al2_asg" {
  name                      = "al2-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_type         = "ELB"                # Using ALB health checks
  health_check_grace_period = 300                  # 5 mins grace
  launch_template {
    id      = aws_launch_template.al2_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [aws_subnet.public_2.id]

  target_group_arns         = [aws_lb_target_group.tg_al2.arn]

  tag {
    key                 = "Name"
    value               = "al2-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group for Amazon Linux 2023
resource "aws_autoscaling_group" "al2023_asg" {
  name                      = "al2023-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_type         = "ELB"                # Using ALB health checks
  health_check_grace_period = 300                  # 5 mins grace
  launch_template {
    id      = aws_launch_template.al2023_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [aws_subnet.public_3.id]

  target_group_arns         = [aws_lb_target_group.tg_al2023.arn]

  tag {
    key                 = "Name"
    value               = "al2023-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
