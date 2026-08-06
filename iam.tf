resource "aws_iam_role" "ec2_ssm_role" {
  count = var.create_ssm_role ? 1 : 0
  name  = "${local.name}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${local.name}-ec2-ssm-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  count      = var.create_ssm_role ? 1 : 0
  role       = aws_iam_role.ec2_ssm_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  count = var.create_ssm_role ? 1 : 0
  name  = "${local.name}-ec2-instance-profile"
  role  = aws_iam_role.ec2_ssm_role[0].name

  tags = {
    Name = "${local.name}-ec2-instance-profile"
  }
}
