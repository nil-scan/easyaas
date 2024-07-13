locals {
  resource_params = jsondecode(file("${get_terragrunt_dir()}/easyaas_resource_params.json"))
  terraform_source = local.resource_params["terraform"]["source"]

  resource = jsondecode(file("${get_terragrunt_dir()}/easyaas_resource.json"))
}

terraform {
  source = local.terraform_source

  # Use tfswitch to install the proper version of terraform
  before_hook "install_terraform" {
    commands = ["init"]
    execute  = ["tfswitch", "--default=$(tfswitch --show-latest)"]
  }
}

# Generate the terraform backend configuration
generate "backend" {
  path      = "backend.tf"
  if_exists = "skip"
  contents = <<END
    terraform {
      backend "kubernetes" {
        namespace = "${local.resource["metadata"]["namespace"]}"
        secret_suffix = "easyaas-${local.resource["metadata"]["name"]}.${local.resource_params["crd"]}"
      }
    }
  END
}

# Generate the terraform.tfvars from the resource spec
generate "tfvars_from_spec" {
  path      = "terraform.tfvars.json"
  if_exists = "skip"
  contents = file("${get_terragrunt_dir()}/easyaas_resource_spec.json")
  disable_signature = true
}
