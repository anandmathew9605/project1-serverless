// modules/dynamodb/variables.tf

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "table_name" {
  type        = string
  description = "Logical table name"
}

variable "partition_key_name" {
  type        = string
  default     = "UserID"
  description = "Partition key attribute name"
}

variable "partition_key_type" {
  type        = string
  default     = "S"
  description = "Partition key data type"
}