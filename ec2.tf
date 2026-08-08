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
  user_data = <<-EOF
              #!/bin/bash
              sudo su ubuntu
              sudo apt update -y
              # install nodejs and npm
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
              export NVM_DIR="$HOME/.nvm"
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
              nvm install --lts
              node -v
              npm -v
              # where install nginx
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo hostnamectl set-hostname ${local.name}-public-ec2 
              echo "<h1>Welcome to ${var.project_name} ${var.environment} environment</h1>" | sudo tee /var/www/html/index.html
            EOF

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

  user_data = <<-EOF
              #!/bin/bash
              sudo su ubuntu
              sudo apt update -y
              # where install nvm and nodejs
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
              export NVM_DIR="$HOME/.nvm"
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
              nvm install --lts
              node -v
              npm -v
              # where install pm2
              npm install pm2@latest -g
              pm2 -v
              sudo hostnamectl set-hostname ${local.name}-private-ec2 
            EOF

  iam_instance_profile = var.create_ssm_role ? aws_iam_instance_profile.ec2_instance_profile[0].name : null

  tags = {
    Name = "${local.name}-private-ec2"
  }
}

resource "aws_instance" "database" {
  ami                         = data.aws_ami.ubuntu_24.id
  instance_type               = var.db_instance_type
  subnet_id                   = aws_subnet.private_2.id
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.database.id
  ]

  key_name = var.key_name

  root_block_device {
    volume_size = var.db_volume_size
    volume_type = var.db_volume_type
    encrypted   = var.db_encrypted
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y postgresql
              sudo systemctl start postgresql
              sudo systemctl enable postgresql
              # where create database and user
              sudo -u postgres psql -c "CREATE DATABASE ${local.name}_db;"
              sudo -u postgres psql -c "CREATE USER ${local.name}_user WITH ENCRYPTED PASSWORD '${local.name}_password';"
              sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${local.name}_db TO ${local.name}_user;"
              sudo hostnamectl set-hostname ${local.name}-db-ec2
            EOF

  iam_instance_profile = var.create_ssm_role ? aws_iam_instance_profile.ec2_instance_profile[0].name : null

  tags = {
    Name = "${local.name}-db-ec2"
    Role = "Database"
  }
}