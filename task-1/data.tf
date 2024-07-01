# # Fetch information about the Artifact Registry repository
data "google_artifact_registry_repository" "image" {
  project       = var.project_id
  repository_id = var.repository_name
  location      = var.region
}