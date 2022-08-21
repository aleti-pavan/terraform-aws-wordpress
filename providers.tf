

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_reg
}

###############


# provider "aws" {
#   region = var.aws_reg
#   # version = "2.12.0"
#   profile = "terraform"
# }

# provider "template" {
#     version = "~> 2.1.2"
# }


