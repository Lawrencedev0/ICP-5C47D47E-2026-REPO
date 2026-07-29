# VPC Security Hardening

## Overview
Security best practices applied to the VPC Network Architecture, following the principle of defense in depth.

---

## 1. Security Groups (Stateful Firewall)

### Bastion Host SG (`sg-bastion`)
| Direction | Type | Protocol | Port Range | Source | Description |
|-----------|------|----------|------------|--------|-------------|
| **Inbound** | SSH | TCP | 22 | YOUR-HOME-IP/32 | Admin SSH access |
| **Outbound** | All | All | All | 0.0.0.0/0 | Outbound internet |

### Web Tier SG (`sg-web`)
| Direction | Type | Protocol | Port Range | Source | Description |
|-----------|------|----------|------------|--------|-------------|
| **Inbound** | HTTP | TCP | 80 | 0.0.0.0/0 | Public web traffic |
| **Inbound** | HTTPS | TCP | 443 | 0.0.0.0/0 | Public web traffic |
| **Outbound** | All | All | All | 0.0.0.0/0 | Outbound internet |

### Application Tier SG (`sg-app`)
| Direction | Type | Protocol | Port Range | Source | Description |
|-----------|------|----------|------------|--------|-------------|
| **Inbound** | Custom TCP | TCP | 8080 | sg-web | Traffic from web tier |
| **Inbound** | SSH | TCP | 22 | sg-bastion | SSH from bastion only |
| **Outbound** | All | All | All | 0.0.0.0/0 | Outbound internet |

### Database Tier SG (`sg-db`)
| Direction | Type | Protocol | Port Range | Source | Description |
|-----------|------|----------|------------|--------|-------------|
| **Inbound** | MySQL/Aurora | TCP | 3306 | sg-app | Traffic from app tier |
| **Inbound** | PostgreSQL | TCP | 5432 | sg-app | Traffic from app tier |
| **Outbound** | All | All | All | 0.0.0.0/0 | Outbound internet |

---

## 2. Network ACLs (Stateless Firewall)

### Public Subnet NACL
| Rule # | Type | Protocol | Port Range | Source/Dest | Allow/Deny |
|--------|------|----------|------------|-------------|------------|
| **Inbound** | | | | | |
| 100 | HTTP | TCP | 80 | 0.0.0.0/0 | ALLOW |
| 110 | HTTPS | TCP | 443 | 0.0.0.0/0 | ALLOW |
| 120 | SSH | TCP | 22 | YOUR-HOME-IP/32 | ALLOW |
| 130 | Ephemeral | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW |
| * | All | All | All | 0.0.0.0/0 | DENY |

| **Outbound** | | | | | |
| 100 | HTTP | TCP | 80 | 0.0.0.0/0 | ALLOW |
| 110 | HTTPS | TCP | 443 | 0.0.0.0/0 | ALLOW |
| 120 | Ephemeral | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW |
| * | All | All | All | 0.0.0.0/0 | DENY |

### Private Subnet NACL
| Rule # | Type | Protocol | Port Range | Source/Dest | Allow/Deny |
|--------|------|----------|------------|-------------|------------|
| **Inbound** | | | | | |
| 100 | App Traffic | TCP | 8080 | 10.0.0.0/16 | ALLOW |
| 110 | SSH | TCP | 22 | 10.0.0.0/16 | ALLOW |
| 120 | DB Traffic | TCP | 3306/5432 | 10.0.0.0/16 | ALLOW |
| * | All | All | All | 0.0.0.0/0 | DENY |

| **Outbound** | | | | | |
| 100 | HTTP | TCP | 80 | 0.0.0.0/0 | ALLOW |
| 110 | HTTPS | TCP | 443 | 0.0.0.0/0 | ALLOW |
| 120 | Ephemeral | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW |
| * | All | All | All | 0.0.0.0/0 | DENY |

---

## 3. VPC Flow Logs

**Configuration:**
- **Destination:** CloudWatch Logs → `/aws/vpc/flow-logs/internship-vpc`
- **Traffic Type:** ALL (accepted and rejected)
- **Format:** Custom (version, account-id, interface-id, srcaddr, dstaddr, srcport, dstport, protocol, action)
- **Retention:** 7 days (dev environment), 30 days (production recommendation)

**Use Cases:**
- Detect anomalous traffic patterns
- Troubleshoot connectivity issues
- Audit network access
- Compliance reporting

---

## 4. Encryption
| Resource | Encryption Method | Status |
|----------|-------------------|--------|
| VPC Flow Logs | CloudWatch Logs encryption (default) | ✅ Configured |
| EBS Volumes | AWS managed keys (SSE) | ✅ Recommended |
| S3 (Terraform state) | Server-side encryption (AES-256) | ✅ Recommended |

---

## 5. Security Best Practices Summary
| Practice | Implementation |
|----------|----------------|
| **Defense in Depth** | Security Groups + NACLs + Flow Logs |
| **Least Privilege** | Minimal inbound/outbound rules |
| **Principle of Least Access** | Bastion for SSH access |
| **Network Segmentation** | Tiered architecture (web, app, db) |
| **Audit Trail** | VPC Flow Logs enabled |
| **No Public Access to Private Resources** | Private subnets have no direct IGW route |
| **Cost-Aware Security** | Single NAT Gateway for dev environment |

---

## References
- [Security Groups vs NACLs](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Security.html)
- [VPC Security Best Practices](https://docs.aws.amazon.com/wellarchitected/latest/security-best-practices/)
- [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)

