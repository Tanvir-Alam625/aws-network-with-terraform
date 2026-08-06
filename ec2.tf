data "aws_ami" "ubuntu_24" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "public" {
  ami                         = data.aws_ami.ubuntu_24.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.public_ec2.id
  ]

  key_name = var.key_name

  root_block_device {
    volume_size = var.public_volume_size
    volume_type = var.public_volume_type
    encrypted   = var.public_encrypted
  }

  iam_instance_profile = var.create_ssm_role ? aws_iam_instance_profile.ec2_instance_profile[0].name : null

  tags = {
    Name = "${local.name}-public-ec2"
  }
}

resource "aws_instance" "private" {
  ami                         = data.aws_ami.ubuntu_24.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.private_ec2.id
  ]

  key_name = var.key_name

  root_block_device {
    volume_size = var.private_volume_size
    volume_type = var.private_volume_type
    encrypted   = var.private_encrypted
  }

  iam_instance_profile = var.create_ssm_role ? aws_iam_instance_profile.ec2_instance_profile[0].name : null

  tags = {
    Name = "${local.name}-private-ec2"
  }
}