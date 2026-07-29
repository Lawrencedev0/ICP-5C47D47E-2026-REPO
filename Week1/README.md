# Week 1: Cloud Fundamentals & Account Setup

## 📅 Objective
Set up the foundation for the internship by learning cloud fundamentals, creating a cloud account, configuring IAM, and selecting projects.

## ✅ Deliverables
- [x] Cloud account created
- [x] IAM users and roles configured
- [x] Project selection document completed
- [ ] All Week 1 tasks documented

---

## 🗓️ Tasks Completed

### 1. Cloud Account Setup
- Created an AWS account (or used existing account)
- Set up billing alerts and budget notifications
- Enabled MFA on root account
- Created an admin IAM user for daily operations

### 2. IAM Configuration
**Users Created:**
| Username | Access Type | Permissions |
|----------|-------------|-------------|
| `admin` | Console + Programmatic | AdministratorAccess |
| `devops` | Programmatic | PowerUserAccess + Custom VPC/Terraform policies |

**Security Best Practices Applied:**
- ✅ Root account MFA enabled
- ✅ Strong password policy enforced
- ✅ Access keys rotated
- ✅ Least privilege principle applied for service users

### 3. Project Selection
**Selected Projects:**
1. **Project 3 – VPC Network Architecture** (Intermediate)
2. **Project 6 – Infrastructure as Code (Terraform)** (Intermediate–Advanced)

**Justification:**
These projects align with my existing knowledge in:
- AWS core services (VPC, EC2, IAM, Route 53, CloudWatch)
- DevOps tools (Docker, Jenkins, Kubernetes, Terraform, CI/CD)
- Infrastructure security (Security Groups, NACLs, IAM policies)
- Networking concepts (subnets, routing, NAT, load balancing)

---

## 📚 Learning Resources Referenced
- [AWS Getting Started](https://aws.amazon.com/getting-started/)
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [AWS Free Tier](https://aws.amazon.com/free/)

## 📝 Notes
- All infrastructure will be built within AWS Free Tier limits where possible
- Terraform state will be managed remotely using S3 + DynamoDB
- Cost monitoring will be implemented from Day 1

