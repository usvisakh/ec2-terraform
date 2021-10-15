provider "aws" {
  region = "us-west-2"
}

module "AWSUSE1PRODDC01" {
  source = "git::ssh://git@gitlab.afonza.com/devops/terraform-modules.git//ec2"

  name     = "visakh-test"
  image    = "ami-013a129d325529d4d"
  key_name = "af-visakh-ssm"

  security_groups      = ["sg-0998437249d92a230"]
  iam_instance_profile = "af-visakh-ssm"

  subnet = "subnet-06b35b3d07ceec3e2"
  scaling = {
    termination_protection = true
    root_volume_size       = var.root_volume_size
    instance_type          = "t2.small"
  }

  tags = {
    Client       = "test"
  }

}