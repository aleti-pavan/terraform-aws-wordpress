Project
=========

This is set up wordpress using AWS infrastructure. We are using terraform to provision infrastructure. Code uses and creates following aws services.

1. VPC and it's contents
2. Subnets, Route Tables, Internet Gateway, Nat Gateway.
3. EC2 instance
4. RDS mysql instance.

Note:  You may get charged by aws for using services
-----


Usage:
=======

provisioning:
-------------

1. git clone <repo>
2. cd <repo-dir>
2. 'terraform init'
3. 'terraform plan'
4. 'terraform apply -auto-approve'

Destroying the Infra:
---------------------
1. Be in the repo directory
2. 'terraform destroy -auto-approve'

