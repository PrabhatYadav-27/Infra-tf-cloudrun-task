variable "project_id" {
  description = "The ID of the project in which to create the Cloud Run service"
  type        = string
}

variable "region" {
  description = "The region in which to create the Cloud Run service"
  type        = string
  default     = "asia-south1"
}

variable "service_name" {
  description = "The name of the Cloud Run service"
  type        = string
}

# variable "image_tag" {
#   description = "The image tag"
#   type        = string
# }

variable "repository_name" {
  description = "The repository name"
  type        = string
}

variable "image_name" {
  description = "The container image to deploy"
  type        = string
}

variable "image_tag" {
  description = "The container image tag"
  type        = string
}
