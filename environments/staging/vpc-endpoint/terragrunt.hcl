include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../..//modules/vpc-endpoint"
}

dependencies {
  paths = ["../vpc"]
}
