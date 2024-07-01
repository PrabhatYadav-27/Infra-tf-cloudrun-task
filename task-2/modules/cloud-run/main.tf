resource "google_cloud_run_service" "cloud_run" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = local.image_url
        ports {
          container_port = 80
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  project  = var.project_id
  service  = google_cloud_run_service.cloud_run.name
  location = google_cloud_run_service.cloud_run.location
  role     = "roles/run.invoker" 
  member   = "allUsers"          
}
