# Testing & Optimization Notes

## Overview
Testing methodology and optimization strategies applied to the Terraform Infrastructure as Code project.

---

## 1. Terraform Code Quality Tests

### Format Check
```bash
# Check formatting across all files
terraform fmt -check -recursive

# Auto-format if needed
terraform fmt -recursive
```

### Validation
```bash
# Validate configuration syntax and modules
terraform validate

# Output example:
# Success! The configuration is valid.
```

### Linting with TFLint
```bash
# Install TFLint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Run TFLint
tflint --recursive

# Common issues caught:
# - Unused variables
# - Deprecated syntax
# - Naming convention violations
```

---

## 2. Security Scanning

### Checkov (Policy as Code)
```bash
# Install Checkov
pip install checkov

# Scan Terraform configurations
checkov -d . --framework terraform

# Example checks:
# - CKV_AWS_126: Ensure encryption is enabled for EBS volumes
# - CKV_AWS_111: Ensure IAM policies are attached only to groups or roles
# - CKV_AWS_134: Ensure S3 bucket has public access block
```

### tfsec
```bash
# Install tfsec
choco install tfsec

# Run security scan
tfsec .

# Results summary:
# - PASSED: 25 checks
# - FAILED: 0 checks
# - EXCLUDED: 2 checks
```

---

## 3. Performance Optimization

### Plan Time Optimization

| Optimization | Before | After | Improvement |
|-------------|--------|-------|-------------|
| Remove unnecessary data sources | 45s | 30s | 33% |
| Use local values where possible | - | - | Reduced complexity |
| Limit provider parallelism | Default | 10 | Stable |

### Resource Optimization

| Resource | Original | Optimized | Savings |
|----------|----------|-----------|---------|
| Root volume | gp2 (20GB) | gp3 (20GB) | ~20% cost reduction |
| NAT Gateway | 2 (HA) | 1 (Single) | $32.40/month |
| CloudWatch retention | 30 days | 7 days | ~70% log storage reduction |
| EC2 instance | t3.small | t2.micro | Free tier eligible |

---

## 4. Testing Results

### Execution Plan Summary
```
Plan: 24 to add, 0 to change, 0 to destroy.

Changes:
  + module.vpc.aws_vpc.this
  + module.vpc.aws_subnet.public[0]
  + module.vpc.aws_subnet.public[1]
  + module.vpc.aws_subnet.private[0]
  + module.vpc.aws_subnet.private[1]
  + module.vpc.aws_internet_gateway.this
  + module.vpc.aws_eip.nat[0]
  + module.vpc.aws_nat_gateway.this[0]
  + module.vpc.aws_route_table.public
  + module.vpc.aws_route_table.private[0]
  + module.vpc.aws_route_table_association.public[0-1]
  + module.vpc.aws_route_table_association.private[0-1]
  + module.security_groups.aws_security_group.bastion
  + module.security_groups.aws_security_group.web
  + module.security_groups.aws_security_group.app
  + module.bastion.aws_security_group.this
  + module.bastion.aws_instance.this
  + module.app_server.aws_security_group.this
  + module.app_server.aws_instance.this
```

### Destructive Test Results
```bash
# Verify destroy plan removes everything expected
terraform plan -destroy \
  | grep -E "(destroy|add|change)"

# Result: 24 to destroy, 0 to add, 0 to change
# Confirmed: Full cleanup works correctly
```

---

## 5. Optimization Strategies Applied

### Code Structure
```hcl
# Before: Duplicated configuration
resource "aws_subnet" "public_1" { ... }
resource "aws_subnet" "public_2" { ... }

# After: Using count
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  ...
}
```

### Variable Validation
```hcl
variable "environment" {
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}
```

### Tag Propagation
```hcl
# Before: Manual tagging per resource
tags = {
  Name = "vpc-${var.environment}"
  Env  = var.environment
}

# After: Provider-level default tags
provider "aws" {
  default_tags {
    tags = var.default_tags
  }
}
```

---

## 6. Monitoring & Alerting

| Metric | Tool | Threshold | Action |
|--------|------|-----------|--------|
| Plan time | Terraform | >60s | Review data sources |
| Apply time | Terraform | >120s | Check resource dependencies |
| State file size | S3 | >5MB | Split into workspaces |
| State lock duration | DynamoDB | >5min | Investigate stuck operations |

---

## 7. Final Optimization Recommendations

1. **Terragrunt** for DRY configuration across environments
2. **Pre-commit hooks** for automated formatting and validation
3. **State splitting** by component for large infrastructures
4. **Provider caching** to speed up `terraform init`
5. **Parallelism tuning** based on resource type
6. **Module versioning** using Git tags for stability

---

## References
- [Terraform Testing](https://developer.hashicorp.com/terraform/tutorials/configuration/test)
- [Terraform Best Practices](https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)
- [Checkov for Terraform](https://www.checkov.io/5.Policy%20Index/terraform.html)

