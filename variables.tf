variable "project_name" {
  description = "Project name prefix for resource naming"
  type        = string
  default     = "three-tier"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Who Made this?"
  type = string
  default = "krishna.sharma"
}

# If you want flexibility for region in future (optional)
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "database_name" {
  description = "Name of initial database to create in postgres"
  type        = string
  default     = "appdb"
}

variable "master_username" {
  description = "Master DB username for postgres"
  type        = string
  default     = "dbuser"
}

# optionally, add secret / sensitive input
variable "master_password" {
  description = "Master DB password for postgres"
  type        = string
  # default = "dbpassword"
  # sensitive   = true
}

variable "notification_emails" {
  description = "List of email addresses to receive notifications"
  type        = list(string)
  default     = ["krishna.sharma@devxconsultancy.com"]
}

