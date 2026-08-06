output "public_ip" {
  value = aws_instance.public.public_ip
}

output "private_ip_public_instance" {
  value = aws_instance.public.private_ip
}

output "private_instance_ip" {
  value = aws_instance.private.private_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}