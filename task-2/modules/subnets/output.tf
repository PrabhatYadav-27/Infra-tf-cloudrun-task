output "subnets_self_link" {
  value = [for subnet in google_compute_subnetwork.subnet : subnet.self_link]
  description = "The Self Link of the subnet"
}