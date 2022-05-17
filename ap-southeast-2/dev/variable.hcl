# Non-prod variables

locals {
  # Network
  vpc_id_var   = "vpc-0b6406593fa86497a" # Non-Prod SIT VPC
  vpc_cidr_var = "10.232.8.0/21"

  pub_subnet2a_id_var = "subnet-09e61ca91ab82fd82" # Public Subnet 2a
  pub_subnet2b_id_var = "subnet-0099fd1ddd57e42c1" # Public Subnet 2b

  prv_subnet2a_id_var = "subnet-08e21a3817b7bae21" # Private Subnet 2a
  prv_subnet2b_id_var = "subnet-07ef305d264f1de8a" # Private Subnet 2b

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
  engine_version_var    = "5.7.mysql_aurora.2.07.2"
}