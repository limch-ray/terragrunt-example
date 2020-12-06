locals {
  queues = toset(["01", "01-dlq", "02", "02-dlq"])
}

module "user_queue" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"

#  for_each = local.queues
#  name = "${var.project_name}-${var.environment}-${each.value}"
  name = "${var.project_name}-${var.environment}-demo"
  kms_master_key_id = "alias/aws/sqs"
  tags = var.tags_common
}
