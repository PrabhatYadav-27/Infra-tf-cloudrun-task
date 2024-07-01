output "cloud_run_url" {
  value       = module.cloud_run.cloud_run_url # will display the url of the cloud run
  description = "The URL of Cloud Run service"
}

# output "vpc_self_link" {
#   value       = module.vpc.vpc_self_link
#   description = "The self link of the vpc"
# }

# output "subnets_self_link" {
#   value       = module.subnet[*].subnets_self_link
#   description = "The self link of the subnet"
# }
