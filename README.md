### aviato-tf-cloudrun-task

- The root module (modules folder) will be inclusing the core terraform files of the cloud run service. Which includes main.tf, output.tf and variable.tf files.
- The calling module will be calling the root module. It will include the main.tf, output.tf, terraform.tfvars and variable.tf files.
## File Structure

```.
├── modules
    ├── cloud-run
│   ├── subnets
          ├── main.tf
│         ├── output.tf
│         └── variable.tf
│   └── vpc
├── backend.tf
├── main.tf

├── output.tf
├── terraform.tfvars
└── variable.tf

```


## Using the google provider in `provider.tf` file

```
provider "google" {
  project = var.project_id
  region  = var.region
}
```

##
Using backend i.e `backend.tf` to store the state files to the respective storage buckets

```
terraform {
  backend "gcs" {
    bucket = "BUCKET_NAME"
    prefix = "terraform/cloud-run"
  }
}
```

### using cloud-run module in `main.tf`
The below is the terraform calling module code. 
- cloud run module
- vpc module
- subnet module

```
module "cloud_run" {
  source          = "./modules/cloud-run"
  project_id      = var.project_id
  region          = var.region
  service_name    = var.service_name
  image           = var.image
  image_tag       = var.image_tag
  repository_name = var.repository_name
}

module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.vpc_name
  project_id = var.project_id
}

module "subnet" {
  source        = "./modules/subnets"
  vpc_self_link = module.vpc.vpc_self_link
  region        = var.region
  subnets       = var.subnets
  project_id    = var.project_id
}
```

## `output.tf`
This file will be giving the output of the cloud run service. The output will be fecting the url from the module `cloud_run`, the `vpc_self_link` and `subnets_self_link` will be printing the self link respectively.

```
output "cloud_run_url" {
  value       = module.cloud_run.cloud_run_url # will display the url of the cloud run
  description = "The URL of Cloud Run service"
}

output "vpc_self_link" {
  value       = module.vpc.vpc_self_link 
  description = "The self link of the vpc" 
}

output "subnets_self_link" {
  value       = module.subnet[*].subnets_self_link
  description = "The self link of the subnet" 
}

```


## For Automating the pipeline we have `cloudbuild.yaml` file
- where  we have Setup the triggers for automating the pipeline once we can set the triggers according to the event or action that we are taking
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
      cd task-2/
      terraform init

```

- `name`: 'hashicorp/terraform:latest': Specifies the Terraform builder image.
- `entrypoint`: 'sh': Overrides the default entrypoint to use a shell.
- `args`: Arguments to pass to the shell.
- `-c`: Indicates that a command string follows.
- `cd task-2/`: Changes the directory to task-2.
- `terraform init`: Initializes Terraform, downloading providers and modules.

# Validate Terraform Configuration
```
- name: 'hashicorp/terraform:latest'
  entrypoint: 'sh'
  args:
    - '-c'
    - |
      cd task-2/
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
      cd task-2/
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
      cd task-2/
      terraform ${_TF_ACTION} -auto-approve

```

- `name`: 'hashicorp/terraform:latest': Specifies the Terraform builder image.
- `entrypoint`: 'sh': Uses a shell as the entrypoint.
- `args`: Arguments to pass to the shell.
- `-c`: Indicates that a command string follows.
- `cd task-2/`: Changes the directory to task-2.
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



## Commands to run  Manually
## Terraform initialization

Run ` terraform init`:
-Use the `terraform init` command to initialize Terraform and set up your working directory. This command performs several key tasks:

- Downloads and installs the specified provider plugins (e.g., Google Cloud provider plugin) if they are not already installed.
- Initializes the backend (if configured) for storing Terraform state.
- Downloads any modules specified in your configuration files.

- Navigate to Your Terraform Configuration Directory:
Open your terminal or command prompt and change directory (cd) to the location of your Terraform configuration files.

## Run `terraform plan`:
Use the `terraform plan` command to generate an execution plan. This command analyzes your configuration and state to determine what actions are necessary to achieve your desired state as defined in your configuration files.
 
 ##   RUN ` terraform Validate` and Confirm:
Verify that the planned changes align with your expectations and infrastructure requirements. If needed, you can adjust your Terraform configuration files (*.tf) and repeat the terraform plan command until you are satisfied with the plan.

##  `terraform apply` Changes:
If you are satisfied with the plan and ready to apply the changes to your infrastructure, you can proceed with terraform apply. This will execute the actions specified in the plan.


## How to clean the infrastructure one done with

## Run `terraform destroy`:
Use the `terraform destroy` command to destroy the infrastructure defined in your Terraform configuration files. This will delete all resources that Terraform manages.


## Conclusion

The development of a reusable Terraform module for setting up common infrastructure components such as a VPC, subnets, and a Cloud Run service has been successfully accomplished. The module is designed to be highly configurable and adheres to Terraform's best practices, ensuring robustness and ease of use for diverse deployment scenarios.

