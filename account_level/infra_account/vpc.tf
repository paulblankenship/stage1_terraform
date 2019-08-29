# This is more for clean up and lock down of defaults, but
# as you can see we are setting the VPC wide CIDR here that
# gets used by the network.tf
resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr_prefix}.0.0/22"
  enable_dns_hostnames = true

  tags {
    Name = "${var.name}"
  }
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-default-sg"
  }

  ingress {
    from_port   = 1
    to_port     = 1
    protocol    = "tcp"
    cidr_blocks = ["127.0.0.1/32"]
  }

  egress {
    from_port   = 1
    to_port     = 1
    protocol    = "tcp"
    cidr_blocks = ["127.0.0.1/32"]
  }
}
