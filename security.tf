resource aws_security_group "mysql" {
  name        = "${var.stack}-DBSG"
  description = "managed by terrafrom for db servers"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.stack}-DBSG"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = ["${aws_security_group.web.id}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource aws_security_group "web" {
  name        = "${var.stack}-webSG"
  description = "This is for ${var.stack}s web servers security group"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.stack}-webSG"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
