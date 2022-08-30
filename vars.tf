variable aws_reg {
  description = "This is aws region"
  default     = "us-east-1"
  type        = string
}

variable stack {
  description = "this is name for tags"
  default     = "terraform"
}

variable username {
  description = "DB username"
}

variable password {
  description = "DB password"
}

variable dbname {
  description = "db name"
}

variable ssh_key {
  default     = "~/.ssh/id_rsa.pub"
  description = "Default pub key"
}

variable ssh_priv_key {
  # default     = "~/.ssh/id_rsa"
  default     = "~/.ssh/wordpress.pem"
  description = "Default private key"
}
