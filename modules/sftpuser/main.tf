locals {
  common_tags = {
    IsTerraform = true
    Environment = var.env
  }
  users = flatten([
    for value in var.user_name : flatten([
      for key in value.pub_key :
      {
        user    = value.user
        pub_key = key
      }
    ])
  ])
   
}

resource "random_pet" "this" {
  length = 2
}

resource "aws_transfer_user" "main" {
  for_each = { for auth in var.user_name : auth.user => auth }
  server_id      = var.sftp_server_id
  user_name      = each.value.user
  role           = aws_iam_role.main.arn
  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/"
    target = "/${var.bucket_name}/${each.value.user}"
  }

  tags = merge(
    local.common_tags,
    {
      "Name" : each.value.user
    }
  )
}

resource "aws_transfer_ssh_key" "main" {
  depends_on = [aws_transfer_user.main]
  for_each  = { for k, v in local.users : k => v }
  server_id = var.sftp_server_id
  user_name = each.value.user
  body      = each.value.pub_key
}
#----------------------------------------------------------
data "aws_iam_policy_document" "assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "main" {
  name               = var.sftp_user_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_doc.json
}

data "aws_iam_policy_document" "role_policy_doc" {
  statement {
    effect  = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      var.bucket_arn
    ]
  }
  statement {
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = [
      "${var.bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "main" {
  name   = format("%s-policy", aws_iam_role.main.name)
  role   = aws_iam_role.main.name
  policy = data.aws_iam_policy_document.role_policy_doc.json
}