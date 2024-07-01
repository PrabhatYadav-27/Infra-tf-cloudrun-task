While deploying this code you can check the below structure of the terraform. 
- The root module (modules folder) will be inclusing the core terraform files of the cloud run service. Which includes `main.tf`, `output.tf` and `variable.tf` files.

- The calling module will be calling the root module. It will include the `main.tf`, `output.tf`, `terraform.tfvars` and `variable.tf` files.

- The `ReadMe.md` file includes the explaination of the terraform code.
```
.
├── ReadMe.md
├── backend.tf
├── main.tf
├── modules
│   ├── main.tf
│   ├── output.tf
│   └── variable.tf
├── output.tf
├── terraform.tfvars
└── variable.tf
```

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

### `output.tf`
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

### Variables in the `variables.tf` for the cloud run service.

```
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
    condition     = can(regex("^.*:.*$", var.image))
    error_message = "Invalid image format. Image should be in the format 'repository:tag'"
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
```

### Passing the values from the `terraform.tfvars` file

```
project_id = "ENTER_PROJECT_ID"
region     = "asia-south1"

# cloud run
service_name = "my-first-cloud-run-svc"
image        = "asia-south1-docker.pkg.dev/ENTER_PROJECT_ID/cloud-run-source-deploy/hello-world@sha256:XXXX"


# vpc 
vpc_name = "my-vpc"

# subnet

subnets = {
  subnet1 = {
    name       = "subnet1"
    cidr_block = "10.0.1.0/24"
  },
  subnet2 = {
    name       = "subnet2"
    cidr_block = "10.0.2.0/24"
  }
}
```

# Terraform Project

This Terraform project manages the infrastructure for GCP VPC, Subnets and Cloud run.

## Usage

### Initialize Terraform

Before using Terraform for the first time or after modifying the provider or module configuration, run `terraform init`. This will initialize the working directory containing Terraform configuration files. It downloads and installs the provider plugins specified in the configuration, such as the Google Cloud provider plugin.


### Plan Changes: 
After initializing Terraform, you can run terraform plan to create an execution plan. This command generates an execution plan showing what Terraform will do when you call terraform apply. It compares the current state of the infrastructure to the desired state described in the Terraform configuration files and identifies any changes that need to be made.

```
terraform plan
```

### Apply Changes:
To apply the changes and provision or modify the infrastructure according to the Terraform configuration, run terraform apply. This command executes the changes proposed in the execution plan generated by terraform plan. Terraform will prompt for confirmation before making any changes to the infrastructure.

```
terraform apply
```

### Cleanup
To tear down the infrastructure provisioned by Terraform and delete all associated resources, you can run terraform destroy. This command will prompt for confirmation before destroying the infrastructure.

```
terraform destroy
```