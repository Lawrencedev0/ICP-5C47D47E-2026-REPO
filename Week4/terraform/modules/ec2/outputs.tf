# EC2 Module Outputs

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.this.arn
}

output "public_ip" {
  description = "Public IP address (if assigned)"
  value       = var.assign_public_ip || var.assign_eip ? (
    var.assign_eip ? aws_eip.this[0].public_ip : aws_instance.this.public_ip
  ) : null
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.this.private_ip
}

output "availability_zone" {
  description = "Availability zone of the instance"
  value       = aws_instance.this.availability_zone
}

output "security_group_id" {
  description = "ID of the security group created for this instance"
  value       = length(var.security_group_ids) > 0 ? null : aws_security_group.this[0].id
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = length(var.security_group_ids) > 0 ? null : aws_security_group.this[0].arn
}

