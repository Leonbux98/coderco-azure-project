# Architecture

## Diagram

```mermaid
flowchart TD
    Dev["👨‍💻 Developer\nPush to main"]

    subgraph CICD["GitHub Actions"]
        T["🧪 Test"]
        B["🐳 Build & Push"]
        A["🚀 Terraform Apply"]
        T --> B --> A
    end

    subgraph AZURE["Azure (UK South)"]
        ACR["Container Registry"]
        CA["Container App"]
        FD["Front Door (HTTPS)"]
        LAW["Log Analytics"]
    end

    DNS["DNS\ntm.labs.coderco.co.uk"]
    User["👤 User"]

    Dev --> CICD
    CICD --> ACR
    CICD --> AZURE
    ACR --> CA
    CA --> LAW
    FD --> CA
    DNS --> FD
    User --> DNS
```

## Components

| Component | Purpose |
|---|---|
| ACR | Stores Docker images |
| Container App | Runs the Flask app |
| Front Door | HTTPS, CDN, global routing |
| Log Analytics | Logs and metrics |
