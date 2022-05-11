locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment

  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  project      = local.project_vars.locals.project_name
  application  = local.project_vars.locals.application_name

  variable_vars        = read_terragrunt_config(find_in_parent_folders("variable.hcl"))
  ami                  = local.variable_vars.locals.ami_var
  instance_type        = local.variable_vars.locals.instance_type_var
  vpc_id               = local.variable_vars.locals.vpc_id_var
  prv_subnet2a_id      = local.variable_vars.locals.prv_subnet2a_id_var
  volume_size          = local.variable_vars.locals.volume_size_var
  volume_type          = local.variable_vars.locals.volume_type_var
  device_name          = local.variable_vars.locals.device_name_var
  iam_instance_profile = local.variable_vars.locals.iam_instance_profile_var

}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance.git//wrappers?ref=v4.0.0"
}

inputs = {
  defaults = { # Default values
    create                      = true
    description                 = "${local.project}-${local.application} Instance for ${local.env}"
    ami                         = "${local.ami}"
    vpc_id                      = "${local.vpc_id}"
    subnet_id                   = "${local.prv_subnet2a_id}"
    associate_public_ip_address = false
    instance_type               = "${local.instance_type}"
    monitoring                  = true
    iam_instance_profile        = "${local.iam_instance_profile}"
    ebs_block_device = [
      {
        device_name = "${local.device_name}"
        volume_type = "${local.volume_type}"
        volume_size = "${local.volume_size}"
        encrypted   = true
      }
    ]
  }

  items = {
    my-instance = {
        name = "one-${local.project}-${local.application}-${local.env}"
    }

    my-second-instance = {
        name = "two-${local.project}-${local.application}-${local.env}"
    }

    my-third-instance = {
        name = "three-${local.project}-${local.application}-${local.env}"
    }
  }

}