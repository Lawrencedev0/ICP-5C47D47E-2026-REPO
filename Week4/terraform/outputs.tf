# Terraform Outputs
# Useful values for reference and integration

# --- VPC Outputs ---

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = var.vpc_cidr
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "availability_zones" {
  description = "Availability zones used for subnets"
  value       = module.vpc.availability_zones
}

# --- Network Outputs ---

output "nat_gateway_ips" {
  description = "Elastic IPs of NAT Gateways (if enabled)"
  value       = module.vpc.nat_gateway_public_ips
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

# --- EC2 Outputs ---

output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.bastion.public_ip
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = module.bastion.instance_id
}

output "app_server_private_ip" {
  description = "Private IP address of the app server"
  value       = module.app_server.private_ip
}

output "app_server_instance_id" {
  description = "Instance ID of the app server"
  value       = module.app_server.instance_id
}

# --- Security Outputs ---

output "bastion_security_group_id" {
  description = "Security Group ID for bastion host"
  value       = module.security_groups.bastion_sg_id
  sensitive   = true
}

output "app_security_group_id" {
  description = "Security Group ID for app servers"
  value       = module.security_groups.app_sg_id
  sensitive   = true
}

# --- State Outputs ---

output "terraform_state_bucket" {
  description = "S3 bucket used for Terraform remote state"
  value       = "internship-terraform-state"
}

output "terraform_state_table" {
  description = "DynamoDB table used for Terraform state locking"
  value       = "internship-terraform-locks"
}

