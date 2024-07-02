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

## For Automating the pipeline we have `cloudbuild.yaml` file
- where  we have Setup the triggers for automating the pipeline once we can set the triggers according to the event or action which we are taking
- here  we can set triggers on the ` Code Push Event`  as soon as we happen to push the code in our source code repository our code build will automatically start
  which will implement the whole code right from building the docker image to implementing and creating the `Infrastructure`.
- We can set the variables  of build in our `gcp` build console for better security.

##  The pipeline builds and pushes a Docker image to the Google Container Registry and then deploys infrastructure using Terraform. 
# Build the Docker Image

```
- name: 'gcr.io/cloud-builders/docker'
  args:
    - 'build'
    - '-t'
    - 'asia-south1-docker.pkg.dev/${_PROJECT_ID}/${_GCR_REPO_NAME}/${_IMAGE_NAME}:${_VERSION}'
    - '.'

```

- `name`: 'gcr.io/cloud-builders/docker': Specifies the Docker builder image provided by Google Cloud.
- `args`: Arguments to pass to the Docker builder.
- `build`: The Docker build command.
- `-t`: Specifies the tag for the Docker image.
asia-south1-docker.pkg.dev/${_PROJECT_ID}/${_GCR_REPO_NAME}/${_IMAGE_NAME}:${_VERSION}: The fully qualified name for the Docker image, including region, project ID, repository name, image name, and version.
- `.`: Indicates that the Docker build context is the current directory.

# Push the Docker Image to Google Container Registry
```
- name: 'gcr.io/cloud-builders/docker'
  args:
    - 'push'
    - 'asia-south1-docker.pkg.dev/${_PROJECT_ID}/${_GCR_REPO_NAME}/${_IMAGE_NAME}:${_VERSION}'

```
- `name`: 'gcr.io/cloud-builders/docker': Specifies the Docker builder image.
- `args`: Arguments to pass to the Docker builder.
- `push`: The Docker push command.
asia-south1-docker.pkg.dev/${_PROJECT_ID}/${_GCR_REPO_NAME}/${_IMAGE_NAME}:${_VERSION}: The fully qualified name of the Docker image to push to the registry.

## Deploy Terraform Code
# Initialize Terraform

```
- name: 'hashicorp/terraform:latest'
  entrypoint: 'sh'
  args:
    - '-c'
    - |
      cd task-1/
      terraform init

```

- `name`: 'hashicorp/terraform:latest': Specifies the Terraform builder image.
- `entrypoint`: 'sh': Overrides the default entrypoint to use a shell.
- `args`: Arguments to pass to the shell.
- `-c`: Indicates that a command string follows.
- `cd task-1/`: Changes the directory to task-1.
- `terraform init`: Initializes Terraform, downloading providers and modules.

# Validate Terraform Configuration
```
- name: 'hashicorp/terraform:latest'
  entrypoint: 'sh'
  args:
    - '-c'
    - |
      cd task-1/
      terraform validate

```

- `terraform validate`: Validates the Terraform configuration files.

# Plan Terraform Changes
```
- name: 'hashicorp/terraform:latest'
  entrypoint: 'sh'
  args:
    - '-c'
    - |
      cd task-1/
      terraform plan -input=false -out=tfplan

```

- `terraform plan` -input=false -out=tfplan: Generates an execution plan and saves it to tfplan.
# Apply Terraform Changes
```
- name: 'hashicorp/terraform:latest'
  entrypoint: 'sh'
  args:
    - '-c'
    - |
      cd task-1/
      terraform ${_TF_ACTION} -auto-approve

```

- `name`: 'hashicorp/terraform:latest': Specifies the Terraform builder image.
- `entrypoint`: 'sh': Uses a shell as the entrypoint.
- `args`: Arguments to pass to the shell.
- `-c`: Indicates that a command string follows.
- `cd task-1/`: Changes the directory to task-1.
- `terraform ${_TF_ACTION} -auto-approve`: Applies the Terraform plan (apply or destroy based on the value of _TF_ACTION) without requiring interactive approval.

 # Logging Configuration
 ```
logsBucket: 'gs://cloud-test-task'  //log_bucket _name
options:
  logging: GCS_ONLY

```

- `logsBucket`: 'gs://cloud-test-task': Specifies a Google Cloud Storage bucket for storing logs.
- `options`: Additional options for the build.
- `logging`: GCS_ONLY: Configures the build to only use Google Cloud Storage for logging.


##  The above configuration ensures that the Docker image is built and pushed to the registry, and the Terraform configuration is applied correctly, with logs stored in a specified Google Cloud Storage bucket.
