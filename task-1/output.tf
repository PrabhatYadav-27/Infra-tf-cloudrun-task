# output "name" {
#     value = google_cloud_run_service.cloud_run.url
#     description = "The URL for Cloud Run Service"
# }

output "image_repo_name" {
    value = data.google_artifact_registry_repository.image.name
}
