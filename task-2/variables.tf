variable "project_id" {
  description = "The ID of the project in which to create the Cloud Run service"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID cannot be empty"
  }
}

variable "region" {
  description = "The region in which to create the Cloud Run service"
  type        = string
  default     = "asia-south1"
  validation {
    condition     = var.region != null
    error_message = "Region must be specified"
  }
  validation {
    condition     = length(regexall("_", var.repository_name)) == 0
    error_message = "Repository name must not include underscores"
  }
}

variable "service_name" {
  description = "The name of the Cloud Run service"
  type        = string
  validation {
    condition     = length(var.service_name) > 0
    error_message = "Service name cannot be empty"
  }
}

variable "image" {
  description = "The container image to deploy"
  type        = string
  validation {
    condition     = var.image != null
    error_message = "Image cannot be null"
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

variable "image_tag" {
  description = "The container image tag"
  type        = string
  validation {
    condition     = var.image_tag != null
    error_message = "image tag must be specified"
  }
}

variable "repository_name" {
  description = "The repository name"
  type        = string
  validation {
    condition     = var.repository_name != null
    error_message = "repository name must be specified"
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
