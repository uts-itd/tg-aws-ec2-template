# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------
#

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load tag-level variables
  tag_vars = read_terragrunt_config(find_in_parent_folders("tag.hcl"))

  # Automatically load project-level variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  # Extract the variables we need for easy access
  # Account Info
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  aws_profile  = local.account_vars.locals.aws_profile
  iam_role     = local.account_vars.locals.aws_iam_role

  # Region Info
  aws_region = local.region_vars.locals.aws_region

  # Tag Info
  application_tag_value    = local.tag_vars.locals.application
  project_tag_value        = local.tag_vars.locals.project
  costcentre_tag_value     = local.tag_vars.locals.costcentre
  env_tag_value            = local.tag_vars.locals.env
  primarycontact_tag_value = local.tag_vars.locals.primarycontact

  # Project Info
  project     = local.project_vars.locals.project_name
  application = local.project_vars.locals.application_name

}

# When using this terragrunt config, terragrunt will generate the file "provider.tf" with the aws provider block before
# calling to terraform. Note that this will overwrite the `provider.tf` file if it already exists.
# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
   default_tags {
    tags = {
     "uts:application"    = "${local.application_tag_value}"
     "uts:project"        = "${local.project_tag_value}"
     "uts:costcentre"     = "${local.costcentre_tag_value}"
     "uts:env"            = "${local.env_tag_value}"
     "uts:primarycontact" = "${local.primarycontact_tag_value}"
   }
 }
  allowed_account_ids = ["${local.account_id}"]
  assume_role {
    role_arn     = "${local.iam_role}"
    session_name = "SESSION_NAME"
    external_id  = "EXTERNAL_ID"
  }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${get_env("TG_BUCKET_PREFIX", "")}terragrunt-${local.project}-${local.application}-${local.account_name}-${local.aws_region}.state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  #  local.environment_vars.locals,
)