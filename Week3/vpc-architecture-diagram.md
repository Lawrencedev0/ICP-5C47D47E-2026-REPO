# VPC Architecture Diagram

```mermaid
graph TB
    subgraph "Internet"
        USERS[("Users")]
    end

    subgraph "AWS Region: us-east-1"
        subgraph "VPC: 10.0.0.0/16"
            
            subgraph "Availability Zone A"
                subgraph "Public Subnet A: 10.0.1.0/24"
                    NATGW[NAT Gateway]
                    BASTION[Bastion Host<br/>t2.micro]
                end
                
                subgraph "Private Subnet A: 10.0.3.0/24"
                    APP_A[App Server<br/>Private Instance]
                end
            end

            subgraph "Availability Zone B"
                subgraph "Public Subnet B: 10.0.2.0/24"
                    ALB[Application<br/>Load Balancer]
                end
                
                subgraph "Private Subnet B: 10.0.4.0/24"
                    APP_B[App Server<br/>Private Instance]
                end
            end

            IGW[Internet Gateway]
            
            subgraph "Route Tables"
                PUBLIC_RT[Public Route Table<br/>0.0.0.0/0 -> IGW]
                PRIVATE_RT[Private Route Table<br/>0.0.0.0/0 -> NATGW]
            end

            subgraph "Security"
                SG[Security Groups<br/>- bastion-sg<br/>- web-sg<br/>- app-sg<br/>- db-sg]
                NACL[Network ACLs<br/>- Public NACL<br/>- Private NACL]
                FLOW[VPC Flow Logs<br/>→ CloudWatch]
            end

        end
    end

    USERS -->|HTTP/HTTPS| IGW
    IGW -->|Port 80/443| ALB
    ALB -->|Port 8080| APP_A
    ALB -->|Port 8080| APP_B
    USERS -->|SSH Port 22| BASTION
    BASTION -->|SSH Port 22| APP_A
    BASTION -->|SSH Port 22| APP_B
    APP_A -->|Outbound Internet| NATGW
    APP_B -->|Outbound Internet| NATGW
    NATGW -->|NAT| IGW

    style USERS fill:#e1f5fe,stroke:#01579b
    style IGW fill:#fff3e0,stroke:#e65100
    style NATGW fill:#f3e5f5,stroke:#6a1b9a
    style BASTION fill:#e8f5e9,stroke:#1b5e20
    style ALB fill:#e8f5e9,stroke:#1b5e20
    style APP_A fill:#fff8e1,stroke:#f57f17
    style APP_B fill:#fff8e1,stroke:#f57f17
    style PUBLIC_RT fill:#e3f2fd,stroke:#1565c0
    style PRIVATE_RT fill:#e3f2fd,stroke:#1565c0
    style SG fill:#fce4ec,stroke:#c62828
    style NACL fill:#fce4ec,stroke:#c62828
    style FLOW fill:#fce4ec,stroke:#c62828
```

## Deployment Architecture Flow

```mermaid
sequenceDiagram
    participant User as User
    participant DNS as Route 53
    participant IGW as Internet Gateway
    participant ALB as Load Balancer
    participant WAF as WAF
    participant App as App Server
    participant DB as Database

    User->>DNS: Request app.example.com
    DNS->>IGW: Resolve to ALB IP
    IGW->>ALB: Forward request
    ALB->>WAF: Inspect request
    WAF->>App: Forward clean request
    App->>DB: Query data
    DB-->>App: Return data
    App-->>ALB: HTTP Response
    ALB-->>User: Return response
```

## Network Traffic Flow Diagram

```mermaid
flowchart LR
    subgraph "Inbound Traffic"
        direction TB
        SRC[Source IP]
        -->|"1. Route: IGW"| IGW2[Internet Gateway]
        -->|"2. Public RT: 0.0.0.0/0→IGW"| ALB2[Load Balancer]
        -->|"3. SG: web-sg"| WEB[Web Tier]
    end

    subgraph "Internal Traffic"
        direction TB
        WEB -->|"4. SG: app-sg<br/>Port 8080"| APP[App Tier]
        APP -->|"5. SG: db-sg<br/>Port 3306/5432"| DB2[(Database)]
    end

    subgraph "Outbound Traffic"
        direction TB
        APP -->|"6. Private RT: 0.0.0.0/0→NAT"| NAT2[NAT Gateway]
        NAT2 -->|"7. SNAT to IGW"| IGW3[Internet Gateway]
        IGW3 -->|"8. Outbound to Internet"| DEST[External Destinations]
    end
```

## Tagging Strategy

| Key | Value | Purpose |
|-----|-------|---------|
| `Project` | VPC-Network | Project identification |
| `Environment` | Development | Environment classification |
| `ManagedBy` | Manual (Week2-3) | Management method |
| `CostCenter` | Internship | Cost allocation |
| `Owner` | Lawrence | Resource ownership |

