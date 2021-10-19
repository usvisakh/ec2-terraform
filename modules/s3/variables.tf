variable "env" {
  description = "Name of the environment"
  type        = string
  default     = "staging"
}


variable "origin_bucket" {
  description = "Name of origin bucket"
  type        = string
  default     = "origin"
}

variable "enable_versioning" {
  description = "Set to true for enable versioning"
  type        = bool
  default     = false
}

variable "enable_riplica" {
  description = "Set to true for enable riplica bucket"
  type        = bool
  default     = false
}

variable "replica_bucket" {
  description = "Name of replica bucket"
  type        = string
  default     = "replica"
}

variable "replica_region" {
  description = "Replica bucket region"
  type        = string
  default     = "us-west-2"
}

variable "log_bucket_name" {
  description = "Name of log bucket"
  type        = string
}


variable "abort_incomplete_multipart_upload_days" {
  description = "Number of days until aborting incomplete multipart uploads"
  type        = number
  default     = 1
}


variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Set to true for enable bucket logging "
  type        = bool
  default     = false
}

variable "skip_random_key" {
  description = "skip random key word in bucket name"
  type        = bool
  default     = true
}

variable "enable_replica_logging" {
  description = "Set to true for enable bucket logging "
  type        = bool
  default     = false
}

variable "log_bucket_lifecycle_rule" {
  description = "Lifecycle rules for this log bucket."
  default     = []
}
