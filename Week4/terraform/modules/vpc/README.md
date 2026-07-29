# VPC Terraform Module

## Overview
Creates a complete VPC environment with public/private subnets, NAT Gateway, Internet Gateway, routing, and VPC Flow Logs.

## Usage
```hcl
module "vpc" {
  source = "git::https://github.com/user/terraform-modules.git//vpc"

  project_name        = "myapp"
  environment         = "dev"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
  enable_nat_gateway  = true
  single_nat_gateway  = true
  enable_flow_logs    = true
}
```

## Features
- Multi-AZ VPC with public/private subnet tiering
- NAT Gateway with Elastic IP for private subnet internet access
- Internet Gateway for public subnet access
- Proper route table configuration and associations
- Optional VPC Flow Logs with CloudWatch integration
- Comprehensive tagging for resource management

## Requirements
| Name | Version |
|------|---------|
| Terraform | >= 1.5.0 |
| AWS Provider | ~> 5.0 |

## Inputs
See `variables.tf` for full documentation.

## Outputs
See `outputs.tf` for full documentation.

