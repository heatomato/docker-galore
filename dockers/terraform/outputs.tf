# EC2 Instance Public IP Address
output "instance_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.example.public_ip
}

# EC2 Instance ID
output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.example.id
}