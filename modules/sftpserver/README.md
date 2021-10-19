Creates an AWS Transfer for SFTP endpoint.

Creates the following resources:

* AWS Transfer for SFTP Server.
* IAM role for logging.
* Route53 record for Transfer endpoint (optional).

## Usage

```hcl
module "sftp" {
  source        = "modules/sftpserver"
  env           = "Infra"
  name          = "sftp-serve-namer"
  bucket_name   = "s3_bucket_name"
  domain_name   = "sftp.domain-name.com"
  iam_role_name = "sftp-logging-role"
  zone_id       = "damain-name_zone_id"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain\_name | Domain name of the SFTP Endpoint as a CNAME record.  Also requires zone\_id. | `string` | `""` | no |
| iam\_role\_name | Name of the AWS Transfer Server IAM Role used for logging to CloudWatch Logs | `string` | `"sftp-logging-role"` | no |
| name | Name of the AWS Transfer Server | `string` | false | yes |
| zone\_id | Route53 Zone ID of the SFTP Endpoint CNAME record.  Also requires domain\_name. | `string` | `""` | no |
| bucket | Name of S3 bucket | `list` | false | yes |
| env | Name of the environment | `string` | yes | no |

## Outputs

| Name | Description |
|------|-------------|
| sftp\_server\_id | Server ID of the AWS Transfer Server (aka SFTP Server) |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->