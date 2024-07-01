# Define the Docker image URL dynamically
locals {
  image_url = "${var.region}-docker.pkg.dev/${var.project_id}/${data.google_artifact_registry_repository.image.name}/${var.image}:${var.image_tag}"
}