project_id = "cloud-run-service-task"
region     = "asia-south1"

# Cloud Run
service_name    = "first_cloud_run"
image           = "httpd"
image_tag       = "latest"
repository_name = "uat-prabhat-repo"

#VPC
vpc_name = "my-vpc"

# Subnet
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
