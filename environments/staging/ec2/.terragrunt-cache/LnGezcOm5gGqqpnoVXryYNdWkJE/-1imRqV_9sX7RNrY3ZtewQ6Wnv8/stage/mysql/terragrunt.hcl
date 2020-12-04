include {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//modules/app"
}

inputs = {
  instance_count = 1
  instance_type  = "t3.nano"
}
