output "vpc_self_link" {
  value       = google_compute_network.vpc.self_link
  description = "The Self Link of the vpc"
}
