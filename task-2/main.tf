# Cloud run service module
module "cloud_run" {
  source          = "./modules/cloud-run"
  project_id      = var.project_id
  region          = var.region
  service_name    = var.service_name
  image           = var.image
  image_tag       = var.image_tag
  repository_name = var.repository_name
}

# vpc module
module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.vpc_name
  project_id = var.project_id
}

# subnet module
module "subnet" {
  source        = "./modules/subnets"
  vpc_self_link = module.vpc.vpc_self_link
  region        = var.region
  subnets       = var.subnets
  project_id    = var.project_id
}