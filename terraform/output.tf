output "application-ip" {
  value = [aws_instance.application.*.public_ip]
}

output "application-details" {
  value = aws_instance.application.*
}

output "application-count" {
  value = length(aws_instance.application)
}

output "instance-ids" {
  value = aws_instance.application.*.id
}