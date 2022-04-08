locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment

  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  project      = local.project_vars.locals.project_name
  application  = local.project_vars.locals.application_name

  variable_vars = read_terragrunt_config(find_in_parent_folders("variable.hcl"))
  vpc_id        = local.variable_vars.locals.vpc_id_var
  vpc_cidr      = local.variable_vars.locals.vpc_cidr_var
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=v4.8.0"
}

inputs = {
  name        = "${local.project}-${local.application}-ec2-sg-${local.env}"
  description = "Security Group for the ${local.project} ${local.application} Instance"

  vpc_id = "${local.vpc_id}"

  # Predefined rules
  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["${local.vpc_cidr}"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}