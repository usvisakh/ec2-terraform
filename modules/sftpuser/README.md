Creates a user for an AWS Transfer for SFTP endpoint.

Creates the following resources:

* AWS Transfer user.
* IAM policy for the user to access S3.
* SSH Keys attached to the Transfer user.
* S3 bucket object(user home directory).

## Usage

```hcl
}
module "sftp_user_alice" {
  source                    = "modules/sftpuser"
  env                       = "environment"
  sftp_server_id            = "s-430feab29e754d71a"
  bucket_name               = "bucket_name"
  bucket_arn                = "arn:********"
  user_name                 = [
                              {
                                user = "username"
                                pub_key = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDoq73UbHELMsuMF0bOf2u5vtAw6aJ6DtVyJ7YAz root@DESKTOP-7HLL80K",
                                            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3uDHhukigfhgjhkjkjferjrtjrjtrgjbCSLDk= root@DESKTOP-H56CL44"  
                                          ]           
                              }                                         
                              ]
allowed_actions             = [
                                "s3:GetObject",
                                "s3:GetObjectACL",
                                "s3:GetObjectVersion",
                                "s3:PutObject",
                                "s3:PutObjectACL",
                                "s3:DeleteObject",
                                "s3:DeleteObjectVersion"
                              ]
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_actions | A list of allowed actions for objects in the backend bucket. | `list(string)` | <pre>[<br>  "s3:GetObject",<br>  "s3:GetObjectACL",<br>  "s3:GetObjectVersion",<br>  "s3:PutObject",<br>  "s3:PutObjectACL",<br>  "s3:DeleteObject",<br>  "s3:DeleteObjectVersion"<br>]</pre> | no |
| env | The name of the environment | `string` | true | no |
| sftp\_server\_id | Server ID of the AWS Transfer Server (aka SFTP Server) | `string` | n/a | yes |
| tags | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |
| user\_name | The name of the user along with ssh key | `list object` | n/a | yes |
| bucket\_name | Name of the S3 bucket | `string` | n/a | yes |
| bucket\_arn | Arn of the S3 bucket | `string` | n/a | yes |

