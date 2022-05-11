# Non-prod variables

locals {
  # Network
  vpc_id_var   = "vpc-0c2d8f9911a97b80d" # Prod Reshub VPC
  vpc_cidr_var = "10.0.0.0/16"

  pub_subnet2a_id_var = "subnet-0cea921323309a492" # Public Subnet 2a
  pub_subnet2b_id_var = "subnet-0a9099171ce2ac02c" # Public Subnet 2b

  prv_subnet2a_id_var = "subnet-0898a7b1a31fcce5e" # Private Subnet 2a
  prv_subnet2b_id_var = "subnet-0dc6deeaddbbcda91" # Private Subnet 2b

  # EC2
  ami_var                  = "ami-0bd2230cfb28832f7" # Amazon Linux kernel 5.10
  instance_type_var        = "t2.small"
  iam_instance_profile_var = "AmazonSSMRoleForInstancesQuickSetup"

  # EBS
  volume_size_var = "20"
  volume_type_var = "gp3"
  device_name_var = "/dev/sdf"

  # Database
  database_name_var     = "NonProd_TEMPDB"
  database_username_var = "NonProd_TEMPDB_Admin"
  intance_class_var     = "db.t3.small"
  engine_version_var    = "5.7.12"
}