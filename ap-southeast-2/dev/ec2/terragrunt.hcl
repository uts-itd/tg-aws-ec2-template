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
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance.git?ref=v3.3.0"
}

inputs = {

  # Naming
  name        = "${local.project}-${local.application}-${local.env}"
  description = "${local.project}-${local.application} Instance for ${local.env}"

  # EC2 Config
  ami                  = "${local.ami}"
  instance_type        = "${local.instance_type}"
  monitoring           = true
  iam_instance_profile = "${local.iam_instance_profile}"

  # Networking
  vpc_id                      = "${local.vpc_id}"
  subnet_id                   = "${local.prv_subnet2a_id}"
  associate_public_ip_address = false

  # EBS
  ebs_block_device = [
    {
      device_name = "${local.device_name}"
      volume_type = "${local.volume_type}"
      volume_size = "${local.volume_size}"
      encrypted   = true
    }
  ]

}