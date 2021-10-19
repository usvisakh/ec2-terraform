terraform {
  backend "s3" {
    shared_credentials_file = "~/.aws/credentials"
    bucket                  = "visakhus"
    key                     = "testqa/terraform-state/terraform.tfstate"
    region                  = "us-west-2"
  }

  required_providers {
    random = ">= 3.1.0"
  }
}