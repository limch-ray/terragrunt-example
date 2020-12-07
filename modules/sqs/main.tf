#locals {
#  queues = toset(["01", "01-dlq", "02", "02-dlq"])
#}

#module "user_queue" {
#  source  = "terraform-aws-modules/sqs/aws"
#  version = "~> 2.0"
#
#  for_each = local.queues
#  name = "${var.project_name}-${var.environment}-${each.value}"
#  name = "${var.project_name}-${var.environment}-demo"
#  kms_master_key_id = "alias/aws/sqs"
#  tags = var.tags_common
#}

terraform {
  required_version = ">= 0.14.0"
}

resource "aws_sqs_queue" se_gateway_bundle_dlq {
  name = "${var.project_name}-${var.environment}-se_gateway_bundle_dlq"
  message_retention_seconds = 1209600
  kms_master_key_id = "alias/aws/sqs"

  tags = var.tags_common
}

resource "aws_sqs_queue" se_gateway_bundle {
  name = "${var.project_name}-${var.environment}-se_gateway_bundle"
  visibility_timeout_seconds = 900
  message_retention_seconds = 1209600
  kms_master_key_id = "alias/aws/sqs"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.se_gateway_bundle_dlq.arn
    maxReceiveCount=2
  })

  tags = var.tags_common
}

resource "aws_sqs_queue" se_gateway_single_dlq {
  name = "${var.project_name}-${var.environment}-se_gateway_single_dlq"
  message_retention_seconds = 1209600
  kms_master_key_id = "alias/aws/sqs"

  tags = var.tags_common
}

resource "aws_sqs_queue" se_gateway_single {
  name = "${var.project_name}-${var.environment}-se_gateway_single"
  visibility_timeout_seconds = 900
  message_retention_seconds = 1209600
  kms_master_key_id = "alias/aws/sqs"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.se_gateway_single_dlq.arn
    maxReceiveCount=2
  })

  tags = var.tags_common
}
