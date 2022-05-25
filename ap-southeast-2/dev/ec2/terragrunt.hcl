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

  user_data = <<-EOT
  #!/bin/bash
  echo "Hello Terragrunt" > ~/file.out
  amazon-linux-extras install ansible2 -y
  yum install git -y
  git clone https://github.com/uts-itd/tg-aws-ec2-template.git /root/tg-aws-ec2-template
  ansible-playbook /root/tg-aws-ec2-template/ansible/playbook.yml  -v > ~/ansible.out
  EOT
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance.git?ref=v3.3.0"
}

dependency "sg" {
  config_path = "../sg-ec2"

  mock_outputs = {
    security_group_id = "sg-04f3ba68558ed7f43"
  }
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

  # Security Group
  vpc_security_group_ids = ["${dependency.sg.outputs.security_group_id}"]

  # Call Ansible
  user_data_base64 = base64encode(local.user_data)

  # EBS
  ebs_block_device = [
    {
      device_name = "${local.device_name}"
      volume_type = "${local.volume_type}"
      volume_size = "${local.volume_size}"
      encrypted   = true
    }
  ]

  metadata_options = {
    instance_metadata_tags = "enabled"
  }

}