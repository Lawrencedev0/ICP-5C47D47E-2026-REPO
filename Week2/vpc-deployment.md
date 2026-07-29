# VPC Deployment Guide

## Overview
Step-by-step deployment of the VPC Network Architecture using AWS Management Console (and optionally AWS CLI).

---

## Prerequisites
- ✅ AWS Account with admin access
- ✅ IAM user with VPC permissions
- ✅ AWS CLI configured (optional)
- ✅ Region selected: `us-east-1`

---

## Deployment Steps

### Step 1: Create VPC

**Console:**
1. Navigate to VPC Dashboard → Your VPCs → Create VPC
2. Resources to create: `VPC only`
3. Name tag: `internship-vpc`
4. IPv4 CIDR: `10.0.0.0/16`
5. Tenancy: `Default`

**CLI Equivalent:**
```bash
aws ec2 create-vpc \
  --cidr-block 10.0.0.0/16 \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=internship-vpc},{Key=Project,Value=VPC-Network}]'
```

### Step 2: Enable DNS Attributes
```bash
aws ec2 modify-vpc-attribute --vpc-id vpc-xxxxxxxx --enable-dns-support
aws ec2 modify-vpc-attribute --vpc-id vpc-xxxxxxxx --enable-dns-hostnames
```

### Step 3: Create Subnets

**Public Subnets:**
```bash
# AZ1
aws ec2 create-subnet \
  --vpc-id vpc-xxxxxxxx \
  --cidr-block 10.0.1.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=public-subnet-az1}]'

# AZ2
aws ec2 create-subnet \
  --vpc-id vpc-xxxxxxxx \
  --cidr-block 10.0.2.0/24 \
  --availability-zone us-east-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=public-subnet-az2}]'
```

**Private Subnets:**
```bash
# AZ1
aws ec2 create-subnet \
  --vpc-id vpc-xxxxxxxx \
  --cidr-block 10.0.3.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=private-subnet-az1}]'

# AZ2
aws ec2 create-subnet \
  --vpc-id vpc-xxxxxxxx \
  --cidr-block 10.0.4.0/24 \
  --availability-zone us-east-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=private-subnet-az2}]'
```

### Step 4: Enable Auto-assign Public IP on Public Subnets
```bash
aws ec2 modify-subnet-attribute \
  --subnet-id subnet-xxxxxxxx \
  --map-public-ip-on-launch

aws ec2 modify-subnet-attribute \
  --subnet-id subnet-yyyyyyyy \
  --map-public-ip-on-launch
```

### Step 5: Create Internet Gateway
```bash
aws ec2 create-internet-gateway \
  --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=internship-igw}]'

aws ec2 attach-internet-gateway \
  --internet-gateway-id igw-xxxxxxxx \
  --vpc-id vpc-xxxxxxxx
```

### Step 6: Create NAT Gateway
```bash
# Allocate Elastic IP
aws ec2 allocate-address --domain vpc

# Create NAT Gateway in public subnet AZ1
aws ec2 create-nat-gateway \
  --subnet-id subnet-xxxxxxxx (public-subnet-az1) \
  --allocation-id eipalloc-xxxxxxxx \
  --tag-specifications 'ResourceType=natgateway,Tags=[{Key=Name,Value=internship-nat-gw}]'
```

### Step 7: Create Route Tables

**Public Route Table:**
```bash
aws ec2 create-route-table \
  --vpc-id vpc-xxxxxxxx \
  --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=public-rt}]'

aws ec2 create-route \
  --route-table-id rtb-xxxxxxxx \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id igw-xxxxxxxx

# Associate with public subnets
aws ec2 associate-route-table \
  --route-table-id rtb-xxxxxxxx \
  --subnet-id subnet-xxxxxxxx

aws ec2 associate-route-table \
  --route-table-id rtb-xxxxxxxx \
  --subnet-id subnet-yyyyyyyy
```

**Private Route Table:**
```bash
aws ec2 create-route-table \
  --vpc-id vpc-xxxxxxxx \
  --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=private-rt}]'

aws ec2 create-route \
  --route-table-id rtb-yyyyyyyy \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id nat-xxxxxxxx

# Associate with private subnets
aws ec2 associate-route-table \
  --route-table-id rtb-yyyyyyyy \
  --subnet-id subnet-xxxxxxxx

aws ec2 associate-route-table \
  --route-table-id rtb-yyyyyyyy \
  --subnet-id subnet-yyyyyyyy
```

### Step 8: Create Security Groups

```bash
# Bastion SG - SSH access
aws ec2 create-security-group \
  --group-name bastion-sg \
  --description "SSH access to bastion host" \
  --vpc-id vpc-xxxxxxxx

aws ec2 authorize-security-group-ingress \
  --group-id sg-xxxxxxxx \
  --protocol tcp \
  --port 22 \
  --cidr YOUR-HOME-IP/32

# Web SG - HTTP/HTTPS from anywhere
aws ec2 create-security-group \
  --group-name web-sg \
  --description "HTTP/HTTPS access to web tier" \
  --vpc-id vpc-xxxxxxxx

aws ec2 authorize-security-group-ingress \
  --group-id sg-yyyyyyyy \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
  --group-id sg-yyyyyyyy \
  --protocol tcp \
  --port 443 \
  --cidr 0.0.0.0/0
```

### Step 9: Enable VPC Flow Logs
```bash
aws ec2 create-flow-logs \
  --resource-type VPC \
  --resource-ids vpc-xxxxxxxx \
  --traffic-type ALL \
  --log-destination-type cloud-watch-logs \
  --log-group-name /aws/vpc/flow-logs/internship-vpc \
  --deliver-logs-permission-arn arn:aws:iam::ACCOUNT-ID:role/FlowLogsRole
```

---

## Verification Checklist
- [ ] VPC created and tagged
- [ ] 4 subnets created (2 public, 2 private)
- [ ] Internet Gateway attached to VPC
- [ ] NAT Gateway running (state: Available)
- [ ] Public route table has route to IGW
- [ ] Private route table has route to NAT GW
- [ ] Public subnets associated with public route table
- [ ] Private subnets associated with private route table
- [ ] Security groups configured
- [ ] Flow Logs enabled
- [ ] All resources tagged appropriately

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| NAT Gateway stuck in "Pending" | Check Elastic IP allocation |
| Cannot SSH to bastion | Verify SG ingress rule and public IP |
| Private instances no internet | Check NAT GW route in private RT |
| Subnet not appearing | Verify CIDR doesn't overlap |

