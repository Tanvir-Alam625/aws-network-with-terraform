data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "public" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.public_ec2.id
  ]

  key_name = var.key_name

  tags = {
    Name = "${local.name}-public-ec2"
  }
}

resource "aws_instance" "private" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.private.id

  vpc_security_group_ids = [
    aws_security_group.private_ec2.id
  ]

  key_name = var.key_name

  tags = {
    Name = "${local.name}-private-ec2"
  }
}