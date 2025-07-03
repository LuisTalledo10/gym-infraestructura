output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private.id, aws_subnet.private2.id]
}

output "public_subnet_ids" {
  value = [aws_subnet.public.id, aws_subnet.public2.id]
}