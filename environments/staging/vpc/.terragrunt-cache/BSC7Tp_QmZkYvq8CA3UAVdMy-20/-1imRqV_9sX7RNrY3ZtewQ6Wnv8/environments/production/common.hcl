locals {
  environment = "production"
  project_name = "ray"
}

inputs = {
  aws_region = "ap-southeast-1"
  project_env_prefix= "${local.project_name}-${local.environment}"
}
