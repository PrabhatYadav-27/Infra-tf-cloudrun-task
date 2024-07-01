variable "project_id" {
  description = "The ID of the project"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID cannot be empty"
  }
}

variable "region" {
  description = "The region in which to you wwanted to create vpc"
  type        = string
  default     = "asia-south1"
  validation {
    condition     = var.region != null
    error_message = "Region must be specified"
  }
}

variable "vpc_name" {
  description = "The vpc name"
  type        = string
  validation {
    condition     = length(var.vpc_name) > 0
    error_message = "VPC name cannot be empty"
  }
}