resource "aws_instance" "amazon_linux_2" {
  ami                    = var.al2_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_2.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = file("${path.module}/userdata/al2_userdata.sh")

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = { Name = "terraform-al2" }
}

resource "aws_instance" "amazon_linux_2023" {
  ami                    = var.al2023_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_3.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = file("${path.module}/userdata/al2023_userdata.sh")

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = { Name = "terraform-al2023" }
}

resource "random_password" "cookie_secret" {
  length  = 64
  special = false
}

resource "aws_instance" "ubuntu" {
  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_1.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = file("${path.module}/userdata/ubuntu_userdata.sh")

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = { Name = "terraform-ubuntu" }
}