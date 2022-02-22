# Set common variables for the project. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.

locals {
  project_name     = "template"
  application_name = "ec2"
}