# Create subnets
resource "google_compute_subnetwork" "subnet" {
  for_each = var.subnets
  project = var.project_id
  name          = each.value.name
  ip_cidr_range = each.value.cidr_block
  network       = var.vpc_self_link
  region        = var.region
}