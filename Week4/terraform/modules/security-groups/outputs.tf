# Security Groups Module Outputs

output "bastion_sg_id" {
  description = "ID of the bastion host security group"
  value       = aws_security_group.bastion.id
}

output "bastion_sg_arn" {
  description = "ARN of the bastion host security group"
  value       = aws_security_group.bastion.arn
}

output "web_sg_id" {
  description = "ID of the web tier security group"
  value       = aws_security_group.web.id
}

output "web_sg_arn" {
  description = "ARN of the web tier security group"
  value       = aws_security_group.web.arn
}

output "app_sg_id" {
  description = "ID of the app tier security group"
  value       = aws_security_group.app.id
}

output "app_sg_arn" {
  description = "ARN of the app tier security group"
  value       = aws_security_group.app.arn
}

output "database_sg_id" {
  description = "ID of the database security group"
  value       = var.create_db_sg ? aws_security_group.database[0].id : null
}

output "all_security_group_ids" {
  description = "Map of all security group IDs"
  value = {
    bastion  = aws_security_group.bastion.id
    web      = aws_security_group.web.id
    app      = aws_security_group.app.id
    database = var.create_db_sg ? aws_security_group.database[0].id : null
  }
}

