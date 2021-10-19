locals {
  bucket_name             = var.skip_random_key == true ? var.origin_bucket : "${var.origin_bucket}-${random_pet.this.id}"
  destination_bucket_name = var.skip_random_key == true ? var.replica_bucket : "${var.replica_bucket}-${random_pet.this.id}"
  replica_region          = var.replica_region
  enable_version          = var.enable_riplica == false && var.enable_versioning == false ? false : true
  common_tags = {
    IsTerraform = true
    Environment = var.env
  }
}

provider "aws" {
  region = data.aws_region.current-region.name
  alias  = "origin"
}

provider "aws" {
  region = local.replica_region
  alias  = "replica"
}

resource "random_pet" "this" {
  length = 2
}

data "aws_caller_identity" "current" {}

data "aws_region" "current-region" {}

data "aws_kms_alias" "replica" {
  provider = aws.replica
  name     = "alias/aws/s3"
}

data "aws_kms_alias" "origin" {
  provider = aws.origin
  name     = "alias/aws/s3"
}
#---------------------------------------------------------------------------------------
module "s3_bucket" {
  depends_on = [module.log_bucket]
  source     = "terraform-aws-modules/s3-bucket/aws"
  version    = "1.25.0"
  bucket     = local.bucket_name
  acl        = "private"
  tags = merge(local.common_tags,
    {
      Name = local.bucket_name
    },
  )
  versioning = {
    enabled = local.enable_version
  }
  lifecycle_rule = [
    {
      id                                     = "MultiPartDelete"
      enabled                                = true
      abort_incomplete_multipart_upload_days = var.abort_incomplete_multipart_upload_days
      expiration = {
        expired_object_delete_marker = true
      }
    },
    {
      id      = "FileRetention"
      enabled = true
      noncurrent_version_expiration = {
        days = 7
      }
    },
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = data.aws_kms_alias.origin.target_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  replication_configuration = try(!var.enable_riplica ? {} : tomap(false), {
    role = aws_iam_role.replication[0].arn

    rules = [
      {
        id       = "EnReplica"
        status   = "Enabled"
        priority = 10

        source_selection_criteria = {
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }

        destination = {
          bucket             = "arn:aws:s3:::${local.destination_bucket_name}"
          storage_class      = "STANDARD"
          replica_kms_key_id = data.aws_kms_alias.replica.target_key_arn
          account_id         = data.aws_caller_identity.current.account_id
          access_control_translation = {
            owner = "Destination"
          }
        }
      },
    ]
  })

  logging = !var.enable_logging ? {} : {
    target_bucket = var.log_bucket_name
    target_prefix = "log/"
  }

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

}
#---------------------------------------------------------------------------------
module "replica_bucket" {
  depends_on = [module.replica_log_bucket]
  count      = var.enable_riplica ? 1 : 0
  source     = "terraform-aws-modules/s3-bucket/aws"
  version    = "1.25.0"
  providers = {
    aws = aws.replica
  }

  bucket = local.destination_bucket_name
  acl    = "private"
  tags = merge(local.common_tags,
    {
      Name = local.destination_bucket_name
    },
  )

  versioning = {
    enabled = true
  }
  lifecycle_rule = [
    {
      id                                     = "MultiPartDelete"
      enabled                                = true
      abort_incomplete_multipart_upload_days = var.abort_incomplete_multipart_upload_days
      expiration = {
        expired_object_delete_marker = true
      }
    },
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = data.aws_kms_alias.replica.target_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  logging = !var.enable_replica_logging ? {} : {
    target_bucket = "logs-${local.destination_bucket_name}"
    target_prefix = "log/"
  }
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

#---------------------------------------------------------------------------------
module "log_bucket" {
  count         = var.enable_logging ? 1 : 0
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "1.25.0"
  bucket        = var.log_bucket_name
  acl           = "log-delivery-write"
  force_destroy = true
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule          = var.log_bucket_lifecycle_rule
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

}
#--------------------------------------------------------------------------------------

module "replica_log_bucket" {
  count   = var.enable_replica_logging ? 1 : 0
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "1.25.0"
  providers = {
    aws = aws.replica
  }
  bucket        = "logs-${local.destination_bucket_name}"
  acl           = "log-delivery-write"
  force_destroy = true
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule          = var.log_bucket_lifecycle_rule
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

}

#--------------------------------------------------------------------------------------------
