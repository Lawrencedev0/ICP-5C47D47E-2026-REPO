# Week 4: Project 2 - Infrastructure as Code (Terraform) - Build Phase

## 📅 Objective
Begin building the Terraform Infrastructure as Code project. Design architecture and create modular Terraform configurations.

## ✅ Deliverables
- [x] Terraform architecture designed
- [x] Main Terraform configuration created
- [x] Variables and outputs defined
- [x] Reusable Terraform modules developed

---

## 🗓️ Tasks Completed

### 1. Terraform Architecture Design
- **Provider:** AWS (us-east-1)
- **State Backend:** S3 + DynamoDB (remote state management)
- **Module Structure:** Modular design with reusable components
- **CI/CD Ready:** Configuration supports pipeline integration

### 2. Terraform Configuration Structure
```
Week4/terraform/
├── main.tf                 # Main configuration
├── variables.tf            # Variable definitions
├── outputs.tf              # Output definitions
├── terraform.tfvars.example # Example variable values
├── backend.tf              # Remote state backend
├── providers.tf            # Provider configuration
├── modules/
│   ├── vpc/                # VPC module (reusable)
│   ├── ec2/                # EC2 instance module
│   └── security-groups/    # Security groups module
```

### 3. Modules Created
| Module | Description | Reusable |
|--------|-------------|----------|
| **VPC** | VPC, subnets, IGW, NAT Gateway, routing | ✅ Yes |
| **EC2** | EC2 instances, security groups, key pairs | ✅ Yes |
| **Security Groups** | Reusable security group rules | ✅ Yes |

---

## 📝 Notes
- All modules follow Terraform best practices
- Variables with sensible defaults for easy reuse
- Tags propagated from root to all resources
- Remote state configured for team collaboration

