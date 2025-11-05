## 🧭 SERVERLESS ARCHITECTURE  

The **Serverless Architecture Project** replicates real-world **deployment and operations** practices using fully managed AWS services. It demonstrates how a modern web application can be hosted, delivered, and maintained entirely through **serverless components**, following DevOps best practices for reliability, automation, and scalability.  

The primary goal is to design an environment that **mimics production standards** — including **environment isolation**, **branch-based workflows**, and **automated pipelines** for both application and infrastructure updates. Every cloud resource is provisioned via **Infrastructure as Code (Terraform)** and integrated with **GitHub Actions CI/CD** for continuous delivery using OIDC-based authentication (no static credentials).  

Development follows an **iterative version plan**, where each release adds enhancements aligned with **DevOps**, **FinOps**, and **SecOps** principles. All version updates, improvements, and future experiments are tracked transparently through the project’s [`CHANGELOG.md`](CHANGELOG.md).  


---

## 🧰 Tools, Infrastructure & Components  

| Category | Tool / Service | Purpose & Usage |
|-----------|----------------|----------------|
| **Infrastructure as Code (IaC)** | **Terraform** | Automates provisioning of all AWS resources. Manages state remotely via S3 and DynamoDB for reliability and locking. |
| **Cloud Storage & Hosting** | **Amazon S3** | Hosts static frontend content (`index.html`, assets, scripts). Separate S3 buckets for Dev and Prod environments, both fully managed through Terraform. |
| **Content Delivery & HTTPS** | **Amazon CloudFront** | Acts as CDN and HTTPS layer for the production site, improving performance and security through global edge caching. |
| **Domain & DNS Management** | **Amazon Route 53** | Manages the domain `anandmathew.site` and subdomains such as `serverless.anandmathew.site`. Provides DNS validation for ACM certificates. |
| **SSL Certificates** | **AWS Certificate Manager (ACM)** | Issues and auto-renews TLS/SSL certificates for the production CloudFront distribution using DNS-based validation. |
| **State Locking** | **Amazon DynamoDB** | Prevents concurrent Terraform operations through state locking, ensuring data consistency during deployments. |
| **Version Control & Branching** | **Git & GitHub** | Git repository (`project1-serverless`) follows a two-branch strategy: `dev` for development, `main` for production releases via PR. |
| **Continuous Integration / Delivery (CI/CD)** | **GitHub Actions** | Automates both application and infrastructure deployments. Distinct workflows handle Dev (`push`) and Prod (`push/PR`) updates. |
| **Authentication & Security** | **GitHub OIDC + AWS IAM Roles** | Enables GitHub Actions to assume AWS IAM roles directly using short-lived tokens, eliminating static credentials and enhancing security posture. |


---

💡 **Additional Notes**
- All AWS resources are tagged consistently (`project = "project1-serverless"`, `managed = "terraform"`).  
- Each environment (`dev` and `prod`) maintains separate backend configurations, state files, and IAM roles.  
- No manual configuration is required beyond Terraform and GitHub


---

## 🏗️ CI/CD Workflow  

The overall design follows a **two-environment serverless architecture** with complete automation for provisioning, deployment, and delivery.

1. **Development Workflow (Branch → `dev`)**  
   - Any push to `dev` triggers two pipelines:  
     - **web-dev.yml:** Syncs `web/src` files to the dev S3 bucket.  
     - **infra-dev.yml:** Runs Terraform `plan` → `apply` for `infra/envs/dev/`.  
   - Enables rapid iteration and testing without affecting production.
2. **Production Workflow (Branch → `main`)**  
   - Pull Requests to `main` trigger preview plans.  
   - Merge or direct push to `main` triggers full deployment:  
     - **web-prod.yml:** Updates the production S3 bucket (served via CloudFront).  
     - **infra-prod.yml:** Executes Terraform `plan` → `apply` for `infra/envs/prod/`.  
   - Uses OIDC authentication to assume temporary AWS roles for secure access.


---

## 🧩 CI/CD Architecture Diagram  

```mermaid
flowchart LR
  A[Developer] -->|push / pull request| B[GitHub Repository]
  B --> C{GitHub Actions}

  subgraph Dev [Development Environment]
    C -->|Push to dev branch| D[web-dev.yml\nSync app to S3 (Dev)]
    C -->|Push to dev branch| E[infra-dev.yml\nTerraform plan & apply]
  end

  subgraph Prod [Production Environment]
    C -->|PR to main| F[infra-prod.yml\nTerraform plan]
    C -->|PR to main| G[web-prod.yml\nSync app to S3 (Prod)]
    F -->|Merge / Push to main| H[infra-prod.yml\nTerraform apply]
    G -->|Merge / Push to main| I[CloudFront + S3 (Prod)]
  end

  H --> J[(S3: Terraform State)]
  H --> K[(DynamoDB: State Lock)]
  I --> L[CloudFront Distribution]
  L --> M[Route53 + ACM]



