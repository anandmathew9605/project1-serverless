# 🧾 CHANGELOG – Serverless Architecture Project

All notable changes to this project are documented here.  
This project follows **semantic versioning** (`MAJOR.MINOR.PATCH`).

---

## [v0.1.0] – 2025-11-05
### 🎯 Foundation & CI/CD Setup
- Established Terraform-managed infrastructure for **S3, Route 53, CloudFront, ACM, and DynamoDB**.  
- Configured **remote state backend** and **state locking** using S3 and DynamoDB.  
- Implemented **environment isolation** (`dev` and `prod`) with distinct Terraform backends and IAM roles.  
- Added **GitHub Actions CI/CD pipelines** for both application and infrastructure workflows.  
- Integrated **GitHub OIDC authentication** for secure, short-lived AWS role assumption (no static credentials).  
- Deployed the initial production website at: **[serverless.anandmathew.site](https://serverless.anandmathew.site)**  

---

## [v0.2.0] – 2025-11-09
### 🚀 Dynamic Backend Integration & Automation Enhancements
- Added a **serverless backend API** using **AWS Lambda**, **API Gateway**, and **DynamoDB** for dynamic visitor tracking.  
- Implemented **backend CI/CD pipelines** (`backend-dev.yml`, `backend-prod.yml`) for automated Lambda deployment via S3 artifact uploads.  
- Defined **dedicated IAM roles** for web, backend, infra, and lambda components to ensure clean isolation and improved security posture.  
- Introduced a **modular Terraform structure** across `core`, `dev`, and `prod` environments for clarity and scalability.  
- Moved **ACM and Route 53** resources to the `core` environment with shared remote-state outputs for production CloudFront integration.  
- Verified **end-to-end deployment automation**:  
  - `dev` → Direct S3 website hosting.  
  - `prod` → CloudFront + ACM + Route 53 DNS alias configuration.  
- Performed **infrastructure drift validation**, confirming that both environments remain consistent and stable post-deployment.  

---

## [v0.3.0] – Planned
### 🔒 Security & Compliance Hardening
- Strengthen IAM least-privilege policies and implement encryption best practices.  
- Add compliance checks, configuration baselines, and improved access controls.  
- Introduce automated policy validation within Terraform pipelines.  

---

## [v0.4.0] – Planned
### 💰 FinOps & Cost Optimization
- Optimize AWS usage with lifecycle rules, caching, and monitoring.  
- Introduce tagging compliance and automated cost reporting.  
- Align infrastructure design with cost-efficient operational principles.  

---

## [v0.5.0] – Planned
### ⚙️ Advanced Operations & Observability
- Implement infrastructure drift detection and configuration change monitoring.  
- Enhance deployment strategies using canary or blue-green rollouts.  
- Integrate observability tooling for complete visibility and performance tracking.  

---

#### 🧭 Maintained by [Anand Mathew](https://anandmathew.site)  
_“Project1 – Serverless Architecture: built with Terraform, AWS, and automation-first principles.”_
