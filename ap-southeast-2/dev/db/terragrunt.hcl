locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment

  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  project      = local.project_vars.locals.project_name
  application  = local.project_vars.locals.application_name

  variable_vars     = read_terragrunt_config(find_in_parent_folders("variable.hcl"))
  vpc_id            = local.variable_vars.locals.vpc_id_var
  vpc_cidr          = local.variable_vars.locals.vpc_cidr_block
  prv_subnet2a_id   = local.variable_vars.locals.prv_subnet2a_id_var
  prv_subnet2b_id   = local.variable_vars.locals.prv_subnet2b_id_var
  database_name     = local.variable_vars.locals.database_name_var
  database_username = local.variable_vars.locals.database_username_var
  instance_class    = local.variable_vars.locals.intance_class_var
  engine_version    = local.variable_vars.locals.engine_version_var
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-rds-aurora.git?ref=v6.1.4"
}

# Need the output of the correct Security Group ID to attach to the Auora DB instance
dependency "sg" {
  config_path = "../sg-db"

  mock_outputs = {
    security_group_id = "sg-000f7400b284f2c75"
  }
}

# Need the output of the parameters from Terraform
dependency "data" {
  config_path = "../parameters"
}

inputs = {

  # Main
  name           = "${local.project}-${local.application}-aurora-${local.env}"
  database_name  = "${local.database_name}"
  engine         = "aurora-mysql"
  engine_version = "${local.engine_version}"
  instance_class = "${local.instance_class}"

  instances = {
    one = {}
  }
  autoscaling_enabled      = true
  autoscaling_min_capacity = 2
  autoscaling_max_capacity = 5

  # Networking
  vpc_id  = "${local.vpc_id}"
  subnets = ["${local.prv_subnet2a_id}", "${local.prv_subnet2b_id}"] # Private Backend Subnets

  # Security
  allowed_security_groups = ["${dependency.sg.outputs.security_group_id}"]
  allowed_cidr_blocks     = ["${local.vpc_cidr}"]
  storage_encrypted       = true
  create_security_group   = true

  create_random_password = false
  master_username        = "${local.database_username}"
  master_password        = "${dependency.data.outputs.secretdb}"

  # Backup
  #backtrack_window        = 259200 # 72 hours # NOT SUPPORTED in Auora MYSQL 5.7.12
  backup_retention_period = 7
  skip_final_snapshot     = true

  # Logs
  monitoring_interval             = 0 # Disable Enhanced Monitoring Metrics
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  # Misc
  db_cluster_parameter_group_name = "default.aurora-mysql5.7"
  apply_immediately               = true

}