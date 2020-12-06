include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../..//modules/ec2"
}

dependencies {
  paths = ["../vpc"]
}

#dependency "vpc" {
#  config_path = "../vpc"
#
#  mock_outputs = {
#    vpc_id = "temporary-dummy-id"
#  }
#  mock_outputs_allowed_terraform_commands = ["validate"]
#
#  skip_outputs = true
#}
#
#inputs = {
#  vpc_id = dependency.vpc.outputs.vpc_id
#}
