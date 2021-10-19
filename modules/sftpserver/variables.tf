variable "name" {
  description = "Name of the AWS Transfer Server"
  type        = string
}

variable "zone_id" {
  description = "Route53 Zone ID of the SFTP Endpoint CNAME record.  Also requires domain_name."
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Domain name of the SFTP Endpoint as a CNAME record.  Also requires zone_id."
  type        = string
  default     = ""
}

variable "env" {
  description = "Name of the environment"
  type        = string
  default     = "staging"
}