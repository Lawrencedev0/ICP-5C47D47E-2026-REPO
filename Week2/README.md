# Week 2: Project 1 - VPC Network Architecture (Build Phase)

## 📅 Objective
Start building the VPC Network Architecture project. Design and deploy the initial VPC infrastructure.

## ✅ Deliverables
- [x] VPC architecture designed
- [x] VPC, subnets, and routing configured
- [x] NAT Gateway deployed
- [x] Initial deployment complete

---

## 🗓️ Tasks Completed

### 1. VPC Design
- Designed a production-ready VPC architecture
- 2 Availability Zones for high availability
- Public and Private subnets in each AZ
- NAT Gateway in public subnet for private subnet internet access

### 2. Infrastructure Deployed

| Component | Configuration | Status |
|-----------|---------------|--------|
| **VPC** | 10.0.0.0/16 | ✅ Deployed |
| **Public Subnet AZ1** | 10.0.1.0/24 | ✅ Deployed |
| **Public Subnet AZ2** | 10.0.2.0/24 | ✅ Deployed |
| **Private Subnet AZ1** | 10.0.3.0/24 | ✅ Deployed |
| **Private Subnet AZ2** | 10.0.4.0/24 | ✅ Deployed |
| **Internet Gateway** | Attached to VPC | ✅ Deployed |
| **NAT Gateway** | Elastic IP, Public subnet AZ1 | ✅ Deployed |
| **Public Route Table** | Routes: 0.0.0.0/0 → IGW | ✅ Configured |
| **Private Route Table** | Routes: 0.0.0.0/0 → NAT GW | ✅ Configured |

### 3. Security Groups Created
| Security Group | Purpose |
|----------------|---------|
| `sg-bastion` | SSH access from trusted IPs |
| `sg-web` | HTTP/HTTPS from ALB |
| `sg-app` | App traffic from web tier |
| `sg-db` | Database traffic from app tier only |

---

## 📝 Notes
- All resources created within AWS Free Tier limits
- VPC Flow Logs enabled for network monitoring
- Tagged all resources with `Project: VPC-Network` and `Environment: Development`

