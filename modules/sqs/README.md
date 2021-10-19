Creates an AWS SQS.

## Usage

```hcl
module "sqs" {
	source            = "modules/sqs"
  queue_name        = "sample_sqs"
  env               = "Infra"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| queue_name | Name for SQS queue | `string` | `""` | yes |
| env | Name of the environment | `string` | true | no |
| visibility\_timeout\_seconds | The visibility timeout for the queue | `number` | 30 | no |
| delay\_seconds | The time in seconds that the delivery of all messages in the queue | `number` | 900 | no |
| receive\_wait\_time\_seconds | Time for which a ReceiveMessage call will wait for a message to arrive before returning | `number` | 0 | no |
| message\_retention\_seconds | The number of seconds Amazon SQS retains a message | `number` | 345600 | no |
| max\_message\_size | The limit of how many bytes a message can contain before Amazon SQS rejects it | `number` | 262144 | no |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->