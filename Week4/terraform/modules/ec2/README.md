# EC2 Terraform Module

## Overview
Creates and manages EC2 instances with configurable security groups, networking, storage, and bootstrapping.

## Usage
```hcl
module "web_server" {
  source = "git::https://github.com/user/terraform-modules.git//ec2"

  project_name      = "myapp"
  environment       = "dev"
  instance_name     = "myapp-dev-web"
  instance_type     = "t2.micro"
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.security_groups.web_sg_id]
  ssh_key_name      = "myapp-key"
  assign_public_ip  = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd
  EOF
}
```

## Features
- Flexible instance configuration with sensible defaults
- Automatic AMI lookup (latest Amazon Linux 2)
- Root volume encryption by default
- IMDSv2 enforcement for security
- Optional Elastic IP assignment
- Custom security group rules
- Detailed CloudWatch monitoring option

## Requirements
| Name | Version |
|------|---------|
| Terraform | >= 1.5.0 |
| AWS Provider | ~> 5.0 |

## Inputs
See `variables.tf` for full documentation.

## Outputs
See `outputs.tf` for full documentation..

