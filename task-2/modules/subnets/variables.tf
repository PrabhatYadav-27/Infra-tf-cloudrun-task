variable "project_id" {
  description = "The ID of the project"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID cannot be empty"
  }
}

variable "region" {
  description = "The region in which you have created the vpc"
  type        = string
  default     = "asia-south1"
  validation {
    condition     = var.region != null
    error_message = "Region must be specified"
  }
}

variable "subnets" {
  description = "Map of subnet configurations."
  type = map(object({
    name       = string
    cidr_block = string
  }))
  validation {
    condition     = can(keys(var.subnets))
    error_message = "Subnets must be provided as a map"
  }
}


variable "vpc_self_link" {
  description = "The self link of the vpc"
  type        = string
}