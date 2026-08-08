variable "project_name" {
  default = "tv"
}

variable "environment" {
  default = "prod"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  default = "10.0.3.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet_2_cidr" {
  default = "10.0.4.0/24"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {
  description = "Existing AWS Key Pair"
}
variable "aws_profile" {
  default = "tv-ostad-aws"
}
variable "aws_region" {
  default = "ap-south-1"
}

variable "create_ssm_role" {
  description = "Set to true only if your AWS account can create IAM roles for SSM access"
  type        = bool
  default     = false
}

variable "public_volume_size" {
  default = 8
}
variable "public_volume_type" {
  default = "gp3"
}
variable "public_encrypted" {
  default = true
}
variable "private_volume_size" {
  default = 8
}
variable "private_volume_type" {
  default = "gp3"
}
variable "private_encrypted" {    
  default = true
}

variable "db_instance_type" {
  default = "t3.medium"
}

variable "db_volume_size" {
  default = 16
}

variable "db_volume_type" {
  default = "gp3"
}

variable "db_encrypted" {
  default = true
}