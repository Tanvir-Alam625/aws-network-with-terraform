variable "project_name" {
  default = "terraform-lab"
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "Existing AWS Key Pair"
}
variable "aws_profile" {
  default = "ofc_tv_aws"
}
variable "aws_region" {
  default = "ap-south-1"
}