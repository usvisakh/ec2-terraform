output "sqs_arn" {
  value = aws_sqs_queue.app_queue.arn
}

output "sqs_id" {
  value = aws_sqs_queue.app_queue.id
}
