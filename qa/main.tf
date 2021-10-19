provider "aws" {
  region = var.region
}
locals {
  s3_folders = ["incoming/archive", "outgoing", "logs"]
  sftp_users = var.sftp_users_with_keys
  users      = [for value in local.sftp_users : value.user]
  folder_struct = { for value in setproduct(local.users, local.s3_folders) :
    "${value[0]}-${value[1]}" => {
      user   = value[0]
      folder = value[1]
    }
  }
  parm_users = flatten([
    for value in var.sftp_users_with_keys : flatten([
      for key in value.pub_key :
      {
        user    = value.user
        pub_key = key
      }
    ])
  ])
  parameters_to_create = [for resource in local.users : resource if fileexists("${resource}.pgp")]
  common_tags = {
    IsTerraform = true
    Environment = var.environment
  }
}

data "aws_caller_identity" "current" {}
#----------------------------S3 bucket--------------------------------#
module "s3_bucket_final" {
  source            = "../modules/s3"
  env               = var.environment
  skip_random_key   = true
  origin_bucket     = var.bucket_name
  enable_versioning = var.enable_versioning
  enable_logging    = var.enable_logging
  log_bucket_name   = var.log_bucket_name
}

#------------------------sftp server---------------------------------------------------

module "sftp" {
  source = "../modules/sftpserver"
  name   = var.sftp_server_name
  env    = var.environment
}

#---------------------------------SFTP user---------------------------------------------

module "sftp_user" {
  source              = "../modules/sftpuser"
  depends_on          = [module.s3_bucket_final]
  sftp_server_id      = module.sftp.sftp_server_id
  user_name           = local.sftp_users
  sftp_user_role_name = var.sftp_user_role_name
  bucket_name         = module.s3_bucket_final.bucket_id
  bucket_arn          = module.s3_bucket_final.bucket_arn
  env                 = var.environment

}

#-------------------s3 userdirectory creation------------------
resource "aws_s3_bucket_object" "folders" {
  depends_on = [module.s3_bucket_final]
  for_each   = local.folder_struct
  bucket     = module.s3_bucket_final.bucket_id
  acl        = "private"
  key        = "${each.value.user}/${each.value.folder}/"
  source     = "/dev/null"
}


#------------------------------------

module "out_sqs" {
  source                      = "../modules/sqs"
  queue_name                  = "test"
  env                         = var.environment
  fifo_queue                  = true
  content_based_deduplication = false

}

# SQS policy created outside of the module
resource "aws_sqs_queue_policy" "out_users_unencrypted_policy" {
  queue_url = module.out_sqs.sqs_id

  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Id": " policy",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action": [
          "SQS:*"
        ],
        "Resource": "${module.out_sqs.sqs_arn}"
      }
    ]
  }
  EOF
}