variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "Key-pair"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ubuntu_ami" {
  description = "Ubuntu 20.04 AMI ID"
  type        = string
  default     = "ami-0731becbf832f281e"
}

variable "al2_ami" {
  description = "Amazon Linux 2 AMI ID"
  type        = string
  default     = "ami-0dc3a08bd93f84a35"
}

variable "al2023_ami" {
  description = "Amazon Linux 2023 AMI ID"
  type        = string
  default     = "ami-02457590d33d576c3"
}

variable "domain_name" {
  description = "Route53 Hosted zone domain name"
  type        = string
  default     = "codelessops.site"
}

variable "admin_email" {
  description = "Email for SSL cert notifications"
  type        = string
  default     = "akifakhan001@hotmail.com"
}
