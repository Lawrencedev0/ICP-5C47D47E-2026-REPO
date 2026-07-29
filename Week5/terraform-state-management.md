# Terraform State Management

## Overview
Best practices and configuration for managing Terraform state remotely using AWS S3 and DynamoDB.

---

## State Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   Remote State Backend                    │
│                                                          │
│  ┌──────────────────────┐     ┌──────────────────────┐   │
│  │      S3 Bucket       │     │    DynamoDB Table    │   │
│  │ internship-terraform │     │ internship-terraform │   │
│  │ -state               │     │ -locks               │   │
│  │                      │     │                      │   │
│  │ env/dev/             │     │ LockID (Primary Key) │   │
│  │   terraform.tfstate  │     │                      │   │
│  │                      │     │ Digest               │   │
│  │ env/staging/         │     │                      │   │
│  │   terraform.tfstate  │     │ Info                 │   │
│  │                      │     │                      │   │
│  │ env/prod/            │     │                      │   │
│  │   terraform.tfstate  │     │                      │   │
│  └──────────────────────┘     └──────────────────────┘   │
│                                                          │
│  Features:                   Features:                   │
│  • Server-side encryption    • Strong consistency        │
│  • Versioning enabled        • Auto-scaling (pay/req)    │
│  • Cross-region replication  • Encryption at rest        │
│  • Lifecycle policies        • TTL-based cleanup         │
└─────────────────────────────────────────────────────────┘
```

---

## Backend Configuration

### `backend.tf`
```hcl
terraform {
  backend "s3" {
    bucket         = "internship-terraform-state"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "internship-terraform-locks"
    encrypt        = true
    # Optional: kms_key_id = "alias/terraform-state-key"
  }
}
```

### Multi-Environment State Isolation

| Environment | State Key | Branch |
|-------------|-----------|--------|
| Development | `env/dev/terraform.tfstate` | `main` (default) |
| Staging | `env/staging/terraform.tfstate` | `staging` branch |
| Production | `env/prod/terraform.tfstate` | `production` branch |

---

## Setup Instructions

### Step 1: Create S3 Bucket
```bash
# Create bucket
aws s3api create-bucket \
  --bucket internship-terraform-state \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket internship-terraform-state \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket internship-terraform-state \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'

# Block public access
aws s3api put-public-access-block \
  --bucket internship-terraform-state \
  --public-access-block-configuration '{
    "BlockPublicAcls": true,
    "IgnorePublicAcls": true,
    "BlockPublicPolicy": true,
    "RestrictPublicBuckets": true
  }'
```

### Step 2: Create DynamoDB Table
```bash
aws dynamodb create-table \
  --table-name internship-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --tags Key=Project,Value=terraform-iac Key=Environment,Value=dev
```

### Step 3: Configure IAM Permissions

**Required IAM Policy for Terraform:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::internship-terraform-state",
        "arn:aws:s3:::internship-terraform-state/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:DescribeTable"
      ],
      "Resource": "arn:aws:dynamodb:us-east-1:*:table/internship-terraform-locks"
    }
  ]
}
```

---

## State Management Commands

```bash
# List all states in backend
terraform state list

# Show details of a specific resource
terraform state show aws_vpc.this

# Move resource in state
terraform state mv aws_vpc.old_module aws_vpc.new_module

# Remove resource from state
terraform state rm aws_vpc.this

# Pull state file to local
terraform state pull > terraform.tfstate.backup

# Push local state to remote
terraform state push terraform.tfstate.backup
```

---

## Best Practices

### Do ✅
- **Always use remote state** for team environments
- **Enable versioning** on the S3 bucket
- **Use state locking** with DynamoDB
- **Isolate environments** using separate state files
- **Encrypt** state at rest
- **Back up** state before major operations
- **Use workspaces** for environment isolation (alternative to separate backends)

### Don't ❌
- **Never edit state files manually** (use `terraform state` commands)
- **Don't commit state files** to Git
- **Avoid storing secrets** in state (use `sensitive = true`)
- **Don't delete** the DynamoDB table without removing locks
- **Avoid sharing** state across unrelated projects

---

## Disaster Recovery

| Scenario | Recovery Plan |
|----------|---------------|
| **Corrupted state** | Restore from S3 versioning or backup |
| **Accidental deletion** | Use `terraform import` to re-import resources |
| **Lock stuck** | Delete DynamoDB lock item manually |
| **Bucket deleted** | Recreate and restore from local backup |
| **Team member left** | Rotate access keys, update IAM policies |

---

## References
- [Terraform State Management](https://developer.hashicorp.com/terraform/language/state)
- [Remote State Backend (S3)](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
- [State Locking](https://developer.hashicorp.com/terraform/language/state/locking)

