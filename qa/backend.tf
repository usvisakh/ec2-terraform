terraform {
  required_version = "~> 0.14.8"
  backend "s3" {
    shared_credentials_file = "~/.aws/credentials"
    bucket                  = "visakhus"
    key                     = "test/terraform-state/terraform.tfstate"
    region                  = "us-west-2"
  }

  required_providers {
    random = ">= 3.1.0"
  }
}