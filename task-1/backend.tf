terraform {
  backend "gcs" {
    bucket = "terraform-tfstate-006"
    prefix = "task1/cloud-run"
  }
}
