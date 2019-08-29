# These configs are to create some account wide resources that lower envs will
# typically use across the entire account but may need to see higher level resource
# or simply placed here so that day to day env work doesn't mistakenly break
# something here.  Typically this is for jumphost SGs or EIPs.
resource "aws_security_group" "winjump_external" {
  name        = "${var.name}_winjump_external"
  description = "Identification group for jump hosts (${var.name} name)"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["${var.external_access_cidr}"]
  }

  tags {
    Name          = "${var.name}-winjump"
    environment   = "infrastructure"
  }
}

resource "aws_security_group" "linjump_external" {
  name        = "${var.name}_linjump_external"
  description = "Identification group for Linux jumphosts (${var.name} name)"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.external_access_cidr}"]
  }

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["${var.external_access_cidr}"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.32.0.0/21"]
  }

  tags {
    Name          = "${var.name}-linjump"
    environment   = "infrastructure"
  }
}

resource "aws_security_group" "base_system" {
  name        = "${var.name}_base_sg"
  description = "Base security group applied to all instances (${var.name} name)"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port       = 3389
    to_port         = 3389
    protocol        = "tcp"
    security_groups = ["${aws_security_group.winjump_external.id}"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.linjump_external.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name          = "${var.name}_basesg"
    environment   = "infrastructure"
  }
}

resource "aws_eip" "winjump" {
  vpc = true

  tags {
    Name = "winjump"
  }


  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eip" "linjump" {
  vpc = true

  tags {
    Name = "linjump"
  }
}
