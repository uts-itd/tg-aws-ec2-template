locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment

  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  project      = local.project_vars.locals.project_name
  application  = local.project_vars.locals.application_name

  variable_vars = read_terragrunt_config(find_in_parent_folders("variable.hcl"))
  vpc_id        = local.variable_vars.locals.vpc_id_var
  subnet2a_id   = local.variable_vars.locals.pub_subnet2a_id_var
  subnet2b_id   = local.variable_vars.locals.pub_subnet2b_id_var
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-alb.git?ref=v6.6.1"
}

dependency "sg" {
  config_path = "../sg-alb"

  mock_outputs = {
    security_group_id = "sg-000f7400b284f2c75"
  }
}

dependency "ec2" {
  config_path = "../ec2"

  mock_outputs = {
    instance_id = "12345"
  }
}

inputs = {
  name        = "${local.project}${local.application}-alb-${local.env}"
  description = "Application Load Balancer for ${local.project} ${local.application} ${local.env}"

  vpc_id          = "${local.vpc_id}"
  security_groups = ["${dependency.sg.outputs.security_group_id}"]
  subnets         = ["${local.subnet2a_id}", "${local.subnet2b_id}"]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix          = "h1"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        server = {
          target_id = "${dependency.ec2.outputs.id}"
          port      = 80
        }
      }
    }
  ]
}