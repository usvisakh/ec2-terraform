locals {
  common_tags = {
    IsTerraform = true
    Name = var.queue_name
    Environment = var.env
  }
  queue_name = var.fifo_queue == true ? "${var.queue_name}.fifo" : var.queue_name

}

#---------------------------------------------------------------------
            #SQS
#----------------------------------------------------------------------
resource "aws_sqs_queue" "app_queue" {
  name                        = local.queue_name
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  delay_seconds               = var.delay_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  message_retention_seconds   = var.message_retention_seconds
  max_message_size            = var.max_message_size
  fifo_queue                  = var.fifo_queue
  tags                        = local.common_tags
  content_based_deduplication = var.content_based_deduplication
}
