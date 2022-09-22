output "ec2instance-ip" {
  value = aws_instance.instance.public_ip
}