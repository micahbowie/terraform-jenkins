# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "replace-me-terraform-state-bucket"
    key     = "replace-me-jenkins.tfstate"
    region  = "us-east-2"
    profile = "terraform-user"
  }
}
