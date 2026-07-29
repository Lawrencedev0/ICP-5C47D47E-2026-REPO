# IAM Configuration Documentation

## Overview
Identity and Access Management (IAM) configuration for secure AWS access management during the internship.

---

## IAM Users Created

### 1. Admin User (`admin`)
| Property | Value |
|----------|-------|
| **Username** | `admin` |
| **Access Type** | AWS Management Console + Programmatic |
| **Password** | Auto-generated (reset on first login) |
| **MFA** | ✅ Enabled (Virtual MFA) |
| **Permissions** | `AdministratorAccess` (managed policy) |

### 2. DevOps User (`devops`)
| Property | Value |
|----------|-------|
| **Username** | `devops` |
| **Access Type** | Programmatic access only |
| **Permissions** | Custom inline policy + `PowerUserAccess` |

#### Custom Inline Policy: `DevOps-VPC-Terraform-Policy`
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "vpc:*",
                "iam:*",
                "s3:*",
                "dynamodb:*",
                "cloudwatch:*",
                "logs:*",
                "elasticloadbalancing:*",
                "autoscaling:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Deny",
            "Action": [
                "iam:DeleteAccountPasswordPolicy",
                "iam:UpdateAccountPasswordPolicy"
            ],
            "Resource": "*"
        }
    ]
}
```

---

## IAM Roles Created

### 1. `EC2-SSM-Role`
For EC2 instances requiring Systems Manager access:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:UpdateInstanceInformation",
                "ssm:ListInstanceAssociations",
                "ec2messages:*"
            ],
            "Resource": "*"
        }
    ]
}
```

### 2. `Terraform-State-Role`
For Terraform state management:
- Trusted entity: AWS account
- Permissions: Full S3 and DynamoDB access for state management

---

## Security Best Practices Applied
| Practice | Status |
|----------|--------|
| Root account MFA | ✅ |
| IAM user MFA | ✅ (admin user) |
| Strong password policy | ✅ (min 12 chars, 1 uppercase, 1 number, 1 special) |
| Access key rotation (90 days) | ✅ |
| Least privilege principle | ✅ |
| No root account access keys | ✅ |
| CloudTrail enabled | ✅ (for audit logging) |

---

## Access Key Management
| User | Access Key ID | Created | Status |
|------|--------------|---------|--------|
| `admin` | AKIA******** | Week 1 | Active |
| `devops` | AKIA******** | Week 1 | Active |

---

## Reference
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [IAM Policy Examples](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html)
- [AWS managed policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html)

