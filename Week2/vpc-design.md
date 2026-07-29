# VPC Network Architecture Design

## Overview
Production-ready VPC architecture designed for high availability, security, and scalability across multiple Availability Zones.

---

## Architecture Design

```
┌─────────────────────────────────────────────────────────────────┐
│                         AWS Region                              │
│                                                                 │
│  ┌──────────────────────────────────────────────────────┐       │
│  │                        VPC                           │       │
│  │                   10.0.0.0/16                        │       │
│  │                                                      │       │
│  │  ┌───────────── AZ1 ─────────┐ ┌───── AZ2 ─────────┐│       │
│  │  │  Public Subnet            │ │  Public Subnet     ││       │
│  │  │  10.0.1.0/24              │ │  10.0.2.0/24       ││       │
│  │  │                           │ │                    ││       │
│  │  │  [NAT Gateway]            │ │                    ││       │
│  │  │  [Bastion Host]           │ │                    ││       │
│  │  │                           │ │                    ││       │
│  │  ├───────────────────────────┤ ├────────────────────┤│       │
│  │  │  Private Subnet           │ │  Private Subnet    ││       │
│  │  │  10.0.3.0/24              │ │  10.0.4.0/24       ││       │
│  │  │                           │ │                    ││       │
│  │  │  [Web/App Servers]        │ │  [Web/App Servers] ││       │
│  │  │                           │ │                    ││       │
│  │  └───────────────────────────┘ └────────────────────┘│       │
│  │                                                      │       │
│  │  ┌──────────────────────────────────────────────────┐│       │
│  │  │         Internet Gateway (IGW)                   ││       │
│  │  └──────────────────────────────────────────────────┘│       │
│  └──────────────────────────────────────────────────────┘       │
│                                                                 │
│  ┌──────────────────────────────────────────────────────┐       │
│  │                    Route Tables                       │       │
│  │  Public RT:  0.0.0.0/0 → IGW                         │       │
│  │  Private RT: 0.0.0.0/0 → NAT Gateway                 │       │
│  └──────────────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────────┘
```

---

## Network Design Details

### VPC Configuration
| Parameter | Value |
|-----------|-------|
| **CIDR Block** | 10.0.0.0/16 |
| **DNS Resolution** | Enabled |
| **DNS Hostnames** | Enabled |
| **Tenancy** | Default |
| **Region** | us-east-1 (N. Virginia) |

### Subnet Design

| Subnet Name | Type | CIDR | AZ | Purpose |
|-------------|------|------|----|---------|
| `public-subnet-az1` | Public | 10.0.1.0/24 | us-east-1a | NAT GW, Bastion, ALB |
| `public-subnet-az2` | Public | 10.0.2.0/24 | us-east-1b | ALB (HA) |
| `private-subnet-az1` | Private | 10.0.3.0/24 | us-east-1a | Application servers |
| `private-subnet-az2` | Private | 10.0.4.0/24 | us-east-1b | Application servers (HA) |

### Routing

#### Public Route Table
| Destination | Target | Purpose |
|-------------|--------|---------|
| 10.0.0.0/16 | Local | VPC internal traffic |
| 0.0.0.0/0 | igw-xxxxxxxx | Internet access |

#### Private Route Table
| Destination | Target | Purpose |
|-------------|--------|---------|
| 10.0.0.0/16 | Local | VPC internal traffic |
| 0.0.0.0/0 | nat-xxxxxxxx | Outbound internet (updates, patches) |

---

## High Availability Design
- **Multi-AZ:** Resources distributed across 2 Availability Zones
- **NAT Gateway:** Single NAT GW (cost-optimized for dev; production would use 1 per AZ)
- **Subnet Pairing:** Each AZ has both public and private subnets

## Security Design
- **Defense in Depth:** Security Groups + Network ACLs
- **Least Privilege:** Minimal inbound/outbound rules
- **Tier Isolation:** Web, App, and Database tiers separated

---

## Cost Optimization
| Component | Cost Saving Strategy |
|-----------|---------------------|
| NAT Gateway | Single NAT GW for both AZs (dev only) |
| VPC | No additional cost |
| Subnets | No additional cost |
| Flow Logs | Logs to CloudWatch with 7-day retention |

---

## References
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/)
- [VPC with Public and Private Subnets (NAT)](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html)
- [Subnet Sizing Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html)

