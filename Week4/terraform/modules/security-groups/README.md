# Security Groups Terraform Module

## Overview
Creates a complete set of security groups for a multi-tier architecture: bastion, web, application, and database tiers.

## Usage
```hcl
module "security_groups" {
  source = "git::https://github.com/user/terraform-modules.git//security-groups"

  project_name      = "myapp"
  environment       = "dev"
  vpc_id            = module.vpc.vpc_id
  allowed_ssh_cidrs = ["203.0.113.0/32"]
  allowed_web_cidrs = ["0.0.0.0/0"]
  create_db_sg      = true
}
```

## Features
- **Bastion SG**: SSH access from trusted IPs only
- **Web SG**: HTTP/HTTPS from the internet
- **App SG**: Internal app traffic from web tier, SSH from bastion only
- **DB SG**: Database ports from app tier only
- Optional additional web ports
- Comprehensive tagging support

## Architecture
```
Internet
    │
    ▼
┌─────────────────────────────────────────────────────┐
│                  Web SG (sg-web)                      │
│  Inbound: 80, 443 from 0.0.0.0/0                     │
│  Outbound: All traffic                                │
└────────────────────┬──────────────────────────────────┘
                     │ Port 8080
                     ▼
┌─────────────────────────────────────────────────────┐
│                  App SG (sg-app)                      │
│  Inbound: 8080 from sg-web, 22 from sg-bastion       │
│  Outbound: All traffic                                │
└────────────────────┬──────────────────────────────────┘
                     │ Port 3306/5432
                     ▼
┌─────────────────────────────────────────────────────┐
│                  DB SG (sg-db)                        │
│  Inbound: 3306, 5432 from sg-app                      │
│  Outbound: All traffic                                │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│                Bastion SG (sg-bastion)                │
│  Inbound: 22 from trusted CIDRs                       │
│  Outbound: All traffic                                │
└─────────────────────────────────────────────────────┘
```

## Requirements
| Name | Version |
|------|---------|
| Terraform | >= 1.5.0 |
| AWS Provider | ~> 5.0 |

## Inputs
See `variables.tf` for full documentation.

## Outputs
See `outputs.tf` for full documentation.

