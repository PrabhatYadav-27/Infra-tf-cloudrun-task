terraform {
  backend "gcs" {
    bucket = "terraform-tfstate-006"
    prefix = "tf/cloud-run"
  }
}
