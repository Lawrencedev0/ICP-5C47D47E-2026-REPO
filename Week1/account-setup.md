# AWS Account Setup Guide

## Overview
This document outlines the steps taken to set up and secure the AWS account for this internship program.

---

## Step 1: Account Creation
- Signed up for AWS at [https://aws.amazon.com](https://aws.amazon.com)
- Used email address associated with the internship
- Selected **Basic support plan** (Free)
- Account ID: *[redacted for security]*

## Step 2: Root Account Security
- ✅ Enabled Multi-Factor Authentication (MFA) using a virtual MFA device (Google Authenticator)
- ✅ Created a strong, unique root account password
- ✅ Set up **AWS Budget** alert for $5/month to avoid unexpected charges
- ✅ Enabled **Cost Explorer** for ongoing monitoring

## Step 3: Billing Alerts
Created CloudWatch billing alarms:
| Alarm Name | Threshold | Action |
|------------|-----------|--------|
| `AWS-Billing-Alert-5` | $5.00 | Email notification |
| `AWS-Billing-Alert-10` | $10.00 | Email notification |
| `AWS-Billing-Alert-20` | $20.00 | Email notification |

## Step 4: AWS Free Tier Usage Plan
To maximize Free Tier usage:
| Service | Free Tier Limit | Our Usage Plan |
|---------|----------------|----------------|
| EC2 (t2.micro) | 750 hours/month | ~1 instance for testing |
| VPC | No additional cost | Full usage |
| NAT Gateway | Not free | Minimize usage, consider NAT instance |
| S3 | 5GB storage | Terraform state only |
| CloudWatch | 10 metrics/alarms | Basic monitoring |

## Step 5: Service Limits
Requested service limit increases where needed:
| Service | Default Limit | Requested Limit |
|---------|--------------|-----------------|
| VPCs per region | 5 | 5 (sufficient) |
| Elastic IPs | 5 | 5 (sufficient) |
| Security Groups per VPC | 500 | 500 (sufficient) |

---

## Reference
- [AWS Account Management](https://docs.aws.amazon.com/accounts/latest/reference/welcome.html)
- [AWS Free Tier](https://aws.amazon.com/free/)
- [AWS Billing and Cost Management](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-what-is.html)

