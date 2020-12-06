locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  project_name = local.common_vars.inputs["project_name"]
  environment = local.common_vars.inputs["environment"]
  project_env_prefix = local.common_vars.inputs["project_env_prefix"]
  aws_region = local.common_vars.inputs["aws_region"]
  tags_common = local.common_vars.inputs["tags_common"]
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
  project_name = local.project_name
  environment = local.environment
  name_prefix = local.project_env_prefix 
  tags_common =  local.tags_common
}
