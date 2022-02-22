locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment

  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  project      = local.project_vars.locals.project_name
  application  = local.project_vars.locals.application_name

  variable_vars = read_terragrunt_config(find_in_parent_folders("variable.hcl"))
  ami           = local.variable_vars.locals.ami_var
  instance_type = local.variable_vars.locals.instance_type_var
  vpc_id        = local.variable_vars.locals.vpc_id_var
  subnet_id     = local.variable_vars.locals.subnet_id_var
  volumne_size  = local.variable_vars.locals.volume_size_var

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
  iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup"

  # Networking
  vpc_id                      = "${local.vpc_id}"
  subnet_id                   = "${local.subnet_id}"
  associate_public_ip_address = false

  # EBS
  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = "${local.volume_size}"
      encrypted   = true
    }
  ]

}