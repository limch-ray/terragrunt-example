module "user_queue" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"

  name = "test-1"
  kms_master_key_id = "alias/aws/sqs"
}
