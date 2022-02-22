# Non-prod variables

locals {
  ami_var           = "ami-0bd2230cfb28832f7" # Amazon Linux kernel 5.10
  instance_type_var = "t2.small"
  vpc_id_var        = "vpc-0b6406593fa86497a"    # Non-Prod SIT VPC
  subnet_id_var     = "subnet-08e21a3817b7bae21" # Private Subnet
  volume_size_var   = "20"

}