# Project 1: VPC Network Architecture - Complete Documentation

## Project Overview
**Project Type:** Intermediate | **Duration:** Weeks 2-3 | **Status:** ✅ Complete

A production-ready Virtual Private Cloud (VPC) network architecture designed for high availability, security, and scalability.

---

## Architecture Summary

```
Internet
    │
    ▼
┌──────────────┐
│  Internet    │
│  Gateway     │
└──────┬───────┘
       │
┌──────▼────────────────────────────────────┐
│           Public Subnets                  │
│  ┌──────────────┐  ┌──────────────┐       │
│  │  AZ1         │  │  AZ2         │       │
│  │  10.0.1.0/24 │  │  10.0.2.0/24 │       │
│  │              │  │              │       │
│  │ [NAT GW]     │  │              │       │
│  │ [Bastion]    │  │              │       │
│  └──────┬───────┘  └──────────────┘       │
└─────────┼─────────────────────────────────┘
          │
┌─────────▼─────────────────────────────────┐
│           Private Subnets                 │
│  ┌──────────────┐  ┌──────────────┐       │
│  │  AZ1         │  │  AZ2         │       │
│  │  10.0.3.0/24 │  │  10.0.4.0/24 │       │
│  │              │  │              │       │
│  │ [App Tier]   │  │ [App Tier]   │       │
│  └──────────────┘  └──────────────┘       │
└───────────────────────────────────────────┘
```

---

## Infrastructure Components

### Network Layer
| Component | Configuration | Quantity |
|-----------|--------------|----------|
| VPC | 10.0.0.0/16 | 1 |
| Public Subnets | 10.0.1.0/24, 10.0.2.0/24 | 2 |
| Private Subnets | 10.0.3.0/24, 10.0.4.0/24 | 2 |
| Availability Zones | us-east-1a, us-east-1b | 2 |
| Internet Gateway | 1 attached to VPC | 1 |
| NAT Gateway | 1 (Elastic IP) | 1 |

### Security Layer
| Component | Details |
|-----------|---------|
| Security Groups | 4 (bastion, web, app, db) |
| Network ACLs | 2 (public, private) |
| Flow Logs | Enabled (CloudWatch, 7-day retention) |

### Routing Layer
| Route Table | Routes |
|-------------|--------|
| Public RT | Local VPC + 0.0.0.0/0 → IGW |
| Private RT | Local VPC + 0.0.0.0/0 → NAT GW |

---

## Key Design Decisions

### 1. Multi-AZ Deployment
**Decision:** Resources distributed across 2 Availability Zones
**Rationale:** Ensures high availability. If one AZ fails, the other continues serving traffic.

### 2. Single NAT Gateway
**Decision:** One NAT Gateway in AZ1
**Rationale:** Cost optimization for development environment. Production would use NAT GW per AZ for HA.

### 3. Security Group + NACL Layers
**Decision:** Both stateful (SG) and stateless (NACL) firewalls
**Rationale:** Defense in depth. SGs provide instance-level security, NACLs provide subnet-level protection.

### 4. Bastion Host Architecture
**Decision:** Single bastion host in public subnet for SSH access
**Rationale:** Minimizes public exposure of resources. All SSH access goes through a single controlled entry point.

---

## Cost Estimate (Monthly)

| Component | Estimated Cost | Notes |
|-----------|---------------|-------|
| NAT Gateway | $32.40 | ~$0.045/hour |
| Data Transfer (NAT) | ~$5.00 | Estimated 50GB outbound |
| VPC Flow Logs | ~$3.00 | CloudWatch logs |
| Elastic IP | $0.00 | While attached to NAT GW |
| **Total** | **~$40.40/month** | Dev environment |

---

## Lessons Learned

### What Went Well
- Multi-AZ design provides clear HA path for production
- Security group tiering cleanly separates concerns
- NAT Gateway simplifies outbound internet for private instances

### Challenges
- NACL rules are stateless, requiring careful ephemeral port management
- NAT Gateway cost is significant even for dev environments
- Flow Logs volume can be high; filtering helps reduce costs

### Improvements for Production
- Deploy NAT Gateway per AZ for HA
- Add Transit Gateway for multi-VPC connectivity
- Implement AWS Network Firewall for advanced threat protection
- Use VPC endpoints (Gateway/Interface) for AWS service access without NAT

---

## Deliverables Status
- [x] VPC, subnets, and routing configured
- [x] NAT Gateway deployed
- [x] Security Groups configured
- [x] Network ACLs configured
- [x] VPC Flow Logs enabled
- [x] Security hardening applied
- [x] Architecture documentation complete
- [x] Architecture diagram created
- [x] Cost estimates documented

