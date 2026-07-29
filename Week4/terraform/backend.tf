# Terraform Remote State Backend
# Backend Type: S3 + DynamoDB
# 
# Prerequisites:
# - S3 Bucket: internship-terraform-state (bucket must exist)
# - DynamoDB Table: internship-terraform-locks (table must exist)
#
# Setup commands:
# aws s3api create-bucket --bucket internship-terraform-state --region us-east-1
# aws dynamodb create-table \
#   --table-name internship-terraform-locks \
#   --attribute-definitions AttributeName=LockID,AttributeType=S \
#   --key-schema AttributeName=LockID,KeyType=HASH \
#   --billing-mode PAY_PER_REQUEST

terraform {
  backend "s3" {
    bucket         = "internship-terraform-state"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "internship-terraform-locks"
    encrypt        = true
  }
}

