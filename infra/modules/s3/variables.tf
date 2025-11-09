// modules/s3/variables.tf

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "bucket_purpose" {
  type        = string
  description = "Short purpose string used in bucket name"
}

variable "enable_versioning" {
  type    = bool
  default = false
}

variable "enable_website_hosting" {
  type    = bool
  default = false
}

variable "index_document_suffix" {
  type    = string
  default = "index.html"
}

variable "error_document_key" {
  type    = string
  default = "error.html"
}

variable "public_access_block" {
  type    = bool
  default = true
  description = "Whether to create a Public Access Block"
}

variable "attach_policy" {
  type    = bool
  default = false
  description = "Whether to attach a custom bucket policy (pass policy_json)"
}

variable "policy_json" {
  type    = string
  default = null
  description = "Policy JSON to attach when attach_policy = true"
}

variable "enable_ownership_controls" {
  type    = bool
  default = true
  description = "Enable ownership controls (BucketOwnerPreferred)"
}