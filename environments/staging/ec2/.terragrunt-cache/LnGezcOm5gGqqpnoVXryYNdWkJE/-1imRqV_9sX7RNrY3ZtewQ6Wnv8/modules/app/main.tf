module "app" {
  source = "../../../app"
  instance_type  = var.instance_type
  instance_count = var.instance_count
}

# infrastructure-modules/app/outputs.tf
output "url" {
  value = module.app.url
}

# infrastructure-modules/app/variables.tf
variable "instance_type" {}
variable "instance_count" {}
