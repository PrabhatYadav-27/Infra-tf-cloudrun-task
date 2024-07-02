# aviato-tf-cloudrun-task


 ## Task-1: Setup Cloud Run with Terraform
- Objective: Create a Cloud Run service on Google Cloud Platform (GCP) using Terraform.
# Requirements:
- Create a new GCP project.
- Enable the required APIs (Cloud Run, Cloud Build, Artifact Registry).
- Create a Docker image for a simple "Hello World" application and push it to Google Artifact Registry 
- Deploy the Docker image to Cloud Run using Terraform.
- Ensure the Cloud Run service is publicly accessible.


## Task-2: Create a New Terraform Module for Reusable Infrastructure Components
- Objective: Develop a reusable Terraform module that can be used to set up common infrastructure components.
# Requirements:
- Create a Terraform module that sets up a VPC, subnets, and a Cloud Run service.
- The module should accept parameters for VPC CIDR, subnet CIDRs, and Cloud Run service configuration (e.g., service name, image, memory allocation).
- Ensure the module follows best practices for Terraform module development (e.g., input validation, output variables, documentation).
- Demonstrate the usage of the module in a sample Terraform configuration.

## For each task we have created the separate branch namely
- aviato/task-1
- aviato/task-2
