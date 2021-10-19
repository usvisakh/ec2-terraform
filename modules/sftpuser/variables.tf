variable "env" {
  description = "Name of the environment"
  type        = string
  default     = "staging"
}


variable "user_name" {
  description = "The name of the user"
  default     = ""
}

variable "bucket_name" {
  description = "The S3 Bucket to use as the home directory"
  type = string
}

variable "sftp_server_id" {
  description = "Server ID of the AWS Transfer Server (aka SFTP Server)"
  type        = string
}

variable "allowed_actions" {
  description = "A list of allowed actions for objects in the backend bucket."
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:GetObjectACL",
    "s3:GetObjectVersion",
    "s3:PutObject",
    "s3:PutObjectACL",
    "s3:DeleteObject",
    "s3:DeleteObjectVersion"
  ]
}

variable "bucket_arn" {
  description = "The S3 Bucket arn"
  type = string
}

variable "sftp_user_role_name" {
  description = "Role name for SFTP user"
  type = string
}