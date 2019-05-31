provider "aws" {
  region = "${var.aws_reg}"
  version = "2.12.0"
}
provider "template" {
    version = "~> 2.1.2"
}
