# # You can use/Define the dockerImage URL link here 
locals {
  image_url = "${var.region}-docker.pkg.dev/${var.project_id}/${data.google_artifact_registry_repository.image.name}/${var.image_name}:${var.image_tag}"
}
# asia-south1-docker.pkg.dev/cloud-run-service-task/uat-prabhat-repo/httpd:latest