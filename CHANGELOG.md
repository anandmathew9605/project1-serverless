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
- Deployed initial production website at: **https://serverless.anandmathew.site**

---

## [v0.2.0] – 2025-11-10
### 🚀 Dynamic Backend Integration & Automation Enhancements
- Added a **serverless backend API** using **AWS Lambda**, **API Gateway**, and **DynamoDB** for visitor tracking.  
- Implemented **backend CI/CD pipelines** (`backend-dev.yml`, `backend-prod.yml`) for automated Lambda deployment via S3 artifact uploads.  
- Separated **IAM roles per component** — web, backend, infra, and lambda — for clean isolation and improved security posture.  
- Introduced **modular Terraform structure** across `core`, `dev`, and `prod` environments for clarity and scalability.  
- Moved **ACM and Route 53** resources to `core` environment with shared remote-state outputs for production CloudFront.  
- Verified **end-to-end deployment automation**:  
  - `dev` → direct S3 website hosting.  
  - `prod` → CloudFront + ACM + Route 53 DNS alias.  
- Conducted **drift validation** and confirmed both environments are consistent and stable.  

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
- Review and align infrastructure with cost-efficient design principles.  

---

## [v0.5.0] – Planned
### ⚙️ Advanced Operations & Observability
- Implement infrastructure drift detection and change monitoring.  
- Enhance deployment strategies with canary or blue-green rollouts.  
- Integrate observability tooling for end-to-end visibility and performance tracking.  

---

#### 🧭 Maintained by [Anand Mathew](https://serverless.anandmathew.site)  
_“Project1 – Serverless Architecture: built with Terraform, AWS, and automation-first principles.”_
