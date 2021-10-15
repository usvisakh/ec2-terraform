provider "aws" {
  region = "us-west-2"
}


module "ec2_complete" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.2.0"
  name = "visakh-test"

  ami                         = "ami-013a129d325529d4d"
  instance_type               = "t2.small"
  subnet_id                   = "subnet-06b35b3d07ceec3e2"
  vpc_security_group_ids      = ["sg-0998437249d92a230"]
  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.root_volume_size
      throughput  = 200
    }
  ]
}