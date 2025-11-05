# 🧭 SERVERLESS ARCHITECTURE  

The **Serverless Architecture Project** replicates real-world **deployment and operations** practices using fully managed AWS services. It demonstrates how a modern static web application can be hosted, delivered, and maintained entirely through **serverless components**, following DevOps best practices for reliability, automation, and scalability.  

The goal is to design an environment that **mimics production standards** — including **environment isolation**, **branch-based workflows**, and **automated pipelines** for both application and infrastructure updates. Every cloud resource is provisioned via **Infrastructure as Code (Terraform)** and integrated with **GitHub Actions CI/CD** for continuous delivery using **OIDC-based authentication** (no static credentials).  

Development follows an **iterative version plan**, where each release adds enhancements aligned with **DevOps**, **FinOps**, and **SecOps** principles. All version updates, improvements, and future experiments are tracked transparently through the project’s [`CHANGELOG.md`](CHANGELOG.md).  

---

## 🧰 Tools, Infrastructure & Components  

| Category | Tool / Service | Purpose & Usage |
|-----------|----------------|----------------|
| **Infrastructure as Code (IaC)** | **Terraform** | Automates provisioning of all AWS resources. Manages remote state via S3 and DynamoDB for reliability and state locking. |
| **Cloud Storage & Hosting** | **Amazon S3** | Hosts static frontend content (`index.html`, assets, styles, scripts). Separate S3 buckets for Dev and Prod environments, managed entirely via Terraform. |
| **Content Delivery & HTTPS** | **Amazon CloudFront** | Acts as CDN and HTTPS layer for the production site, improving performance and security through edge caching. |
| **Domain & DNS Management** | **Amazon Route 53** | Manages the root domain `anandmathew.site` and subdomain `serverless.anandmathew.site`. Handles DNS validation for ACM certificates. |
| **SSL Certificates** | **AWS Certificate Manager (ACM)** | Issues and auto-renews TLS/SSL certificates for CloudFront via DNS-based validation. |
| **State Locking** | **Amazon DynamoDB** | Prevents concurrent Terraform operations through state locking, ensuring consistency during deployments. |
| **Version Control & Branching** | **Git & GitHub** | Git repository (`project1-serverless`) follows a two-branch model: `dev` for development, `main` for production releases via pull requests. |
| **Continuous Integration / Delivery (CI/CD)** | **GitHub Actions** | Automates both application and infrastructure deployments. Distinct workflows handle Dev (`push`) and Prod (`PR/push`) operations. |
| **Authentication & Security** | **GitHub OIDC + AWS IAM Roles** | Allows GitHub Actions to assume AWS IAM roles using short-lived tokens, eliminating static credentials and strengthening security posture. |

---

## 🏗️ CI/CD Workflow  

This architecture uses a **two-environment serverless design** with complete automation for provisioning, deployment, and delivery.  

1. **Development Workflow (`dev` branch)**  
   - Any push to `dev` triggers two pipelines:  
     - **`web-dev.yml`** — Syncs `web/src` files to the Dev S3 bucket.  
     - **`infra-dev.yml`** — Executes Terraform `plan` → `apply` in `infra/envs/dev/`.  
   - Enables rapid iteration and testing without impacting production.  

2. **Production Workflow (`main` branch)**  
   - Pull requests to `main` trigger plan/previews for validation.  
   - Merge or direct push to `main` triggers full deployment:  
     - **`web-prod.yml`** — Deploys updated content to the Prod S3 bucket (served via CloudFront).  
     - **`infra-prod.yml`** — Executes Terraform `plan` → `apply` in `infra/envs/prod/`.  
   - Uses **OIDC-based role assumption** for secure, credential-free AWS access.  

---

## 🧩 Versioning & Maintenance  

- The project follows an **incremental versioning model**, where each version introduces new components or enhancements.  
- All updates, improvements, and experiments are logged in [`CHANGELOG.md`](CHANGELOG.md).  
- Git version tags (`v0.1.0`, `v0.2.0`, etc.) are maintained for easy tracking.  
- Each release is validated through automated CI/CD pipelines before merging to `main`.  

**Infrastructure standards:**  
- All AWS resources are consistently tagged (`project = "project1-serverless"`, `managed = "terraform"`).  
- Each environment (`dev` and `prod`) maintains separate backend configurations, state files, and IAM roles.  
- Manual configuration is minimal — Terraform and GitHub Actions manage the entire workflow end-to-end.  

### **Current Release**
> **v0.1.0 – Foundation & CI/CD Setup**  
> Initial version providing a complete Terraform-based serverless architecture with environment-specific CI/CD pipelines.
