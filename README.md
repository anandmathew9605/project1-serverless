# Project: **project1-serverless**

---

## 🎯 Objectives
- **Primary:** Learn & apply different DevOps/IaC tools.  
- **Secondary:** Mimic a production-grade setup after iterations.  
- **Tagging:**  
  - `project = "project1-serverless"`  
  - `managed = "terraform"`

---

## 🧰 Tech Stack (v1 scope)
S3 (static hosting), CloudFront, Route53, DynamoDB, Terraform, GitHub, GitHub Actions, HTML/CSS.  
*(API Gateway, Lambda, CloudWatch, etc. in later versions.)*

---

## 🗂 Version Plan
- **v1:** Foundation & CI/CD (minimal) — get it running.  
- **v2:** Enhancements & add services.  
- **v3:** Security best practices.  
- **v4:** FinOps best practices.  
- **v5:** Advanced enhancements per tool.

---

## 🚀 Current Focus: **v1**

### 1) GitHub Repository
- **Repo:** `anandmathew9605/project1-serverless`  
- **Branches:** `main`, `dev`  
- **Flow:** Direct commits → `dev`; PRs → `main`

---

### 2) Domain
- **Purchased:** `anandmathew.site` (Namecheap)

---

### 3) Route 53
- **Hosted Zone:** Created  
- **NS records at registrar:** Updated  
- **DNS check:** Confirmed  
- **Pending work:** (as noted by you)

---

### 4) State Backend (CLI, minimal)
- **S3:** For Terraform state (dev & prod) — `"project1-serverless-terraform-state"` *(created)*  
- **DynamoDB:** For state locking — `"project1-serverless-tf-locks"` *(created)*  
- **Note:** Backend S3 & lock table **untracked**

---

### 5) Terraform
- Configure backend & state lock  
- From here: all resources via Terraform (IAM current user)

---

### 6) Static Website Buckets
- **Create:** S3 buckets for dev and prod (minimal)  
- **Enable:** Static website hosting  
- **Import:** Route53 hosted zone

---

### 7) Dev Bucket
- **Upload:** `index.html`, `error.html`, CSS, JS (available)  
- **Test:** Access dev site

---

### 8) Prod Bucket + CDN
- **CloudFront (Terraform):** HTTP → HTTPS  
- **ACM (Terraform):** Certificates  
- **Domain:** Serve at `serverless.anandmathew.site`  
- **Test:** Access prod site

---

### 9) Workflows (GitHub Actions)
- **CI1 (dev, frontend):** Any commit to frontend → update **dev S3** content  
- **CI2 (dev, terraform):** Any commit to Terraform (dev) → apply to **dev**  
  - **Secrets:** used for CI1 & CI2  
- **CI3 (prod, frontend):** Any PR to frontend → update **prod S3** content  
- **CI4 (prod, terraform):** Any PR to Terraform (prod) → apply to **prod**  
  - **OIDC:** used for CI3 & CI4

---

## 📝 Notes
- Analyse & review, give suggestions (one task at a time).  
- Keep replies **short & clear**.  
- Do **not add anything extra** without confirming (e.g., extra tagging).  
- Follow naming convention for resources → `"project1-serverless-*logical_naming*"`.  
- Confirm we’re on the same page before proceeding.  
- Don’t jump to steps directly — *I will tell what to do*.

