## Introduction

This repo is to be used as a benchmark to be copied and forked for future AWS EC2 deployments

## Environments

- Dev
- Prod

## Pre-requirements

If you are doing deployment and testing from your own local workstation have a look at this
https://synergy.itd.uts.edu.au/display/CET/Setup+Terragrunt


## Create and manage your infrastructure

Dev is a standard environment with one ALB, one EC2 instance, one DB (for illustration purposes) and some Security Groups to tie it all together.
Ansible is used to configure the EC2 instance itself, by installing and configuring Apache along with other SOE tasks.

Prod just creates a number of EC2 instances but creates them using the 'for_each' mechanism found in the underlying terraform module. 
This is a cleaner and more scalable method of deployment.
Same principe applies to deploy other resources once the module itself supports it.

This is a good place to look to see what modules support it. If not, one can always write their own.
https://github.com/terraform-aws-modules


## To do

- Try and create a module for the alb that supports for_each
- Try and create a module for the security groups that supports for_each
- Dynamicly find the disk name before paritioning it in Ansible (its hardcoded for now)
- Add some way of adding an inventory inside Ansible to the code can be used for any environment

## Author

This project is created and maintained by [CloudEnablementTeam]This is a generic repo that should be forked and modified for your application needs.

To work with this code on your laptop you will need to follow [these instructions](https://synergy.itd.uts.edu.au/display/CET/Setup+Terragrunt) 

You can use the [Getting Started](https://github.com/uts-itd/getting-started) repository for other guides and to find out how to ask for help with your code.
