# Get Parameter from Parameter store

# Get Data
data "aws_ssm_parameter" "getsecret" {
    name = "/dev/template/ec2/database/password"
}

# Output Data
output "secretdb" {
  value = data.aws_ssm_parameter.getsecret.value
  sensitive = true
}
