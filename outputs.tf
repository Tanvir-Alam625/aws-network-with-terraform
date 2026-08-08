output "public_ip" {
  value = aws_instance.public.public_ip
}

output "private_ip_public_instance" {
  value = aws_instance.public.private_ip
}

output "private_instance_ip" {
  value = aws_instance.private.private_ip
}

output "database_instance_ip" {
  value = aws_instance.database.private_ip
}

output "public_subnet_ids" {
  value = [aws_subnet.public.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private.id, aws_subnet.private_2.id]
}

output "vpc_id" {
  value = aws_vpc.main.id
}