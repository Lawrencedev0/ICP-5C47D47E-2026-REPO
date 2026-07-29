# Main Terraform Configuration
# Orchestrates all infrastructure modules

locals {
  environment_prefix = "${var.project_name}-${var.environment}"
}

# --- VPC Module ---
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_vpn_gateway   = var.enable_vpn_gateway
  enable_flow_logs     = var.enable_flow_logs
  flow_logs_retention  = var.flow_logs_retention_days

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# --- Security Groups Module ---
module "security_groups" {
  source = "./modules/security-groups"

  vpc_id             = module.vpc.vpc_id
  project_name       = var.project_name
  environment        = var.environment
  allowed_ssh_cidrs  = var.allowed_ssh_cidrs
  allowed_web_cidrs  = var.allowed_web_cidrs
}

# --- EC2 Module ---
module "bastion" {
  source = "./modules/ec2"

  project_name        = var.project_name
  environment         = var.environment
  instance_type       = var.bastion_instance_type
  ami_id              = var.ami_id
  subnet_id           = module.vpc.public_subnet_ids[0]
  security_group_ids  = [module.security_groups.bastion_sg_id]
  ssh_key_name        = var.ssh_key_name
  assign_public_ip    = true
  instance_name       = "${local.environment_prefix}-bastion"

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
  EOF
}

module "app_server" {
  source = "./modules/ec2"

  project_name        = var.project_name
  environment         = var.environment
  instance_type       = var.app_instance_type
  ami_id              = var.ami_id
  subnet_id           = module.vpc.private_subnet_ids[0]
  security_group_ids  = [module.security_groups.app_sg_id]
  ssh_key_name        = var.ssh_key_name
  assign_public_ip    = false
  instance_name       = "${local.environment_prefix}-app"

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent

    # Install and start a simple web server
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd

    # Create sample index page
    echo "<html><body><h1>App Server: ${local.environment_prefix}-app</h1><p>Environment: ${var.environment}</p></body></html>" > /var/www/html/index.html
  EOF
}

# --- VPC Flow Logs (if enabled) ---
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name              = "/aws/vpc/flow-logs/${local.environment_prefix}"
  retention_in_days = var.flow_logs_retention_days

  tags = {
    Name        = "${local.environment_prefix}-vpc-flow-logs"
    Environment = var.environment
  }
}

