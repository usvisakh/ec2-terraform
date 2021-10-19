variable "region" {
  description = "region name"
  type        = string
}
variable "sftp_users_with_keys" {
  description = "sftp users with SSH key"
  default     = []
}

variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "To enable bucket versioning"
  type        = bool
  default     = false
}


variable "sftp_server_name" {
  description = "Name of the sftp server"
  type        = string
}

variable "enable_logging" {
  description = "Set to true for enable bucket logging "
  type        = bool
  default     = false
}


variable "log_bucket_name" {
  description = "Name of log bucket"
  type        = string
}

variable "sftp_user_role_name" {
  description = "Role name for SFTP user"
  type        = string
}