locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  project_env_prefix = local.common_vars.inputs["project_env_prefix"]
  aws_region = local.common_vars.inputs["aws_region"]
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "${local.project_env_prefix}-tf-state"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "${local.project_env_prefix}-tf-state"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "${local.aws_region}"
}
EOF
}

inputs = {
  name_prefix = local.project_env_prefix 
}
