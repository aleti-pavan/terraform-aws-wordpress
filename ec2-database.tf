
# resource "aws_key_pair" "keypair1" {
#   key_name   = "${var.stack}-keypairs"
#   public_key = file(var.ssh_key)
# }

resource "aws_key_pair" "keypair1" {
  key_name   = "${var.stack}-keypairs"
  public_key = file(var.ssh_key)
}

data "template_file" "phpconfig" {
  template = file("files/conf.wp-config.php")

  vars = {
    db_port = aws_db_instance.mysql.port
    db_host = aws_db_instance.mysql.address
    db_user = var.username
    db_pass = var.password
    db_name = var.dbname
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = var.dbname
  username               = var.username
  password               = var.password
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.mysql.id]
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  skip_final_snapshot    = true
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  depends_on = [
    aws_db_instance.mysql,
  ]

  # key_name                    = aws_key_pair.keypair1.key_name
  # vpc_security_group_ids      = [aws_security_group.web.id]
  # subnet_id                   = aws_subnet.public1.id
  # associate_public_ip_address = true
  # user_data = file("files/userdata.sh")
  # key_name                    = "${aws_key_pair.keypair1.key_name}"
  key_name                    = "wordpress"
  vpc_security_group_ids      = ["${aws_security_group.web.id}"]
  subnet_id                   = "${aws_subnet.public1.id}"
  associate_public_ip_address = true

  user_data = "${file("files/userdata.sh")}"

  tags = {
    Name = "EC2 Instance"
  }

  provisioner "file" {
    source      = "files/userdata.sh"
    destination = "/tmp/userdata.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/userdata.sh",
      "/tmp/userdata.sh",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  provisioner "file" {
    content     = data.template_file.phpconfig.rendered
    destination = "/tmp/wp-config.php"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/wp-config.php /var/www/html/wp-config.php",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  timeouts {
    create = "20m"
  }
}
#############################################################################################################################
#*****************************************Adding code for installing Nginx using Ansible ***********************************#
#############################################################################################################################

resource "aws_instance" "nginx" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  # ami                         = "ami-0dba2cb6798deb6d8"
  # subnet_id                   = "subnet-060a1ae52cf0a73d6"
  # associate_public_ip_address = true
  # security_groups             = [aws_security_group.nginx.id]
  
  depends_on = [
    aws_db_instance.mysql,
  ]

  key_name                    = "wordpress"
  vpc_security_group_ids      = ["${aws_security_group.web.id}"]
  subnet_id                   = "${aws_subnet.public1.id}"
  associate_public_ip_address = true


  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    # connection {
    #   type        = "ssh"
    #   user        = local.ssh_user
    #   private_key = file(local.private_key_path)
    #   host        = aws_instance.nginx.public_ip
    # }
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }
  provisioner "local-exec" {
    # command = "ansible-playbook  -i ${aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} nginx.yaml"
    # private_key = file(var.ssh_priv_key)
    command = "ansible-playbook -i ${aws_instance.nginx.public_ip}, --private-key ${(var.ssh_priv_key)} nginx.yaml"
  }
}

output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}

  ##########################################################################################################################
  ##########################################################################################################################


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
