# tg-aws-ec2-template

Basic EC2 template to be reused by other teams.  
More info outlining this process, and how this repo works, can be found at..  
https://synergy.itd.uts.edu.au/display/TSSYS/Deploy+EC-2+using+Terraform+and+Github+actions  

# Overview
[ServiceConnect](https://uts.service-now.com/nav_to.do?uri=%2Fincident.do%3Fsys_id%3D850ee2dfdb733010b96bdbf2f3961913%26sysparm_stack%3D%26sysparm_view%3D)
This repository is used to create the ec2 instance in the UTS AWS Sandpit account.

You can clone this repository to create your own ec2-instance. To do so please update the variables highlighted below and update the GitHub secrets.  

# Assumptions
We are using the UTS AWS Sandpit account, meaning the vpc and subnet can be deleted at any time and may no longer exist.  
**If you get errors validate the subnet id is still valid.**  

# Code
Code is run from the following directory /dev/ec2/terragrunt.hcl
IAC is run using [Terragrunt](https://terragrunt.gruntwork.io/docs/#getting-started)

# Tags
 Please follow the cloud resource tagging policy as tags are mandatory and resource creation will fail if not followed.
 [Cloud Resource Tagging](https://synergy.itd.uts.edu.au/display/CET/Cloud+Resource+Tagging)

# Secrets
AWS secrets have been added to the repository and Branch protection is enabled on Main.

# AWS Account
UTS AWS Sandpit - 046955552049

# Variables
inputs = {  
    ami                           = "ami-0a443decce6d88dc2"  
    subnet_id                     = "subnet-0c8b76c7eec2602ed"  
    root_block_device             = [
                                      {volume_size = 500},  
  ]  
    tags = {"Name"                = "Data-Catalog-Evaluation",  
            "uts:costcentre"      = "702010",  
            "uts:project"         = "Data-Catalog-Evaluation",  
            "uts:env"             = "test"
            "uts:primarycontact"  = "<Your.name>@uts.edu.au"}  

# Changes
Changes to this branch can only be made via a Pull Request that triggers the pipeline that will create the resource The Pull Request must be approved by at least one person from the BI or Cloud Enablement Teams. This process is enforced by [GitHub Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches).