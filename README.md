# aviato-tf-cloudrun-task

### Using the google provider in `provider.tf` file

```
provider "google" {
  project = var.project_id
  region  = var.region
}
```

###
Using backend i.e `backend.tf` to store the state files to the respective storage buckets

```
terraform {
  backend "gcs" {
    bucket = "BUCKET_NAME"
    prefix = "terraform/cloud-run"
  }
}
```
### The below terraform code in `main.tf` will create the cloud run service. It accepts 
- name: name of the cloud run service 
- location: location in which you wanted to deploy the service
- image name: Image name
- container port: Container port on which image will be running
- traffic weight %: Percentage to direct the traffic
```
resource "google_cloud_run_service" "cloud_run" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
```

### 
The below terraform code will help to create the iam service member. To restrict the users to access to cloud run service. It accepts the below parameters
- service: service name of the cloud run service
- location: In which location your cloud service is deployed
- role: to access the cloud run invoker using roles/run.invoker permission
- members: addng allUsers to access the cloud run service
```
resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.cloud_run.name
  location = google_cloud_run_service.cloud_run.location
  role     = "roles/run.invoker" 
  member   = "allUsers"        
}
```

### Variables in the `variables.tf` for the cloud run service.

```
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

variable "image_tag" {
  description = "The container image tag"
  type        = string
}

variable "repository_name" {
  description = "The repository name"
  type        = string
}

variable "image" {
  description = "The container image to deploy"
  type        = string
}
```

### This `output.tf` below output code will print the cloud run url.

```
output "cloud_run_url" {
  value       = google_cloud_run_service.cloud_run.status[0].url # will display the url of the cloud run
  description = "The URL of Cloud Run service"
}
```


### Passing the values from the `terraform.tfvars` file

```
project_id   = "ENTER_PROJECT_ID"
region       = "asia-south1"
service_name = "my-first-cloud-run-svc"
image        = "asia-south1-docker.pkg.dev/ENTER_PROJECT_ID/repository_name/image"_name: tag_name"
```
