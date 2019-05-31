What's this:
=========

This is to set up wordpress using AWS infrastructure. We are using terraform to provision infrastructure. Code uses and creates following aws services.

1. VPC and it's components
2. Subnets, Route Tables, Internet Gateway, Nat Gateway.
3. EC2 instance
4. EIP for NAT Gateway
5. RDS mysql instance.
6. Security Groups to access both EC2 and MYSQL

Note:  
-----
You may get charged by aws for using services


Usage:
=======

provisioning:
-------------

1. git clone https://github.com/aleti-pavan/terraform-aws-wordpress.git
2. cd terraform-aws-wordpress
2. terraform init
3. terraform plan
4. terraform apply -auto-approve

Destroying the Infra:
---------------------
1. cd terraform-aws-wordpress (Be in the repo directory)
2. terraform destroy -auto-approve



Change:
------ 

Code slightly changed on 31st May, 2019. 
I have added providers.tf with versions required for each provider