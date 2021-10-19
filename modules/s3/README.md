# AWS S3 bucket Terraform module

Terraform module which creates S3 bucket on AWS with all (or almost all) features provided by Terraform AWS provider.


### Module

```hcl
odule "s3_final_bucket" {
  source                 = "git::ssh://git@gitlab.afonza.com/devops/terraform-modules.git//s3"
  env                    = "Production"
  skip_random_key        = true
  origin_bucket          = "origin-bucket"
  enable_versioning      = true
  enable_riplica         = true
  replica_bucket         = "replica-bucket"
  replica_region         = "us-west-2"
  enable_logging         = true
  enable_replica_logging = true
}
```

* [Reference](https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/blob/master/README.md)
