# These configs are to create some account wide resources that lower envs will
# typically use across the entire account but may need to see higher level resource
# or simply placed here so that day to day env work doesn't mistakenly break
# something here.  Typically this is for jumphost SGs or EIPs.
resource "aws_security_group" "web_frontend" {
  name        = "${var.name}_web_frontend"
  description = "SG used for web server front ends like HAProxy, Apache, Nginx, whatever is the external facing service"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.external_access_cidr}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.external_access_cidr}"]
  }

  tags {
    Name          = "${var.name}-web_frontend"
    environment   = "infrastructure"
  }
}

resource "aws_security_group" "app_backend" {
  name        = "${var.name}_app_backend"
  description = "SG used to provide access to the front end layer to the application later itself"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.base_sg}"]
  }

  # This is just a redirect to 443 or 8443, right?
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_security_group.app_frontend.id}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_security_group.app_frontend.id}"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${aws_security_group.app_frontend.id}"]
  }

  tags {
    Name          = "${var.name}-app_backend"
    environment   = "infrastructure"
  }
}

resource "aws_eip" "web_frontend" {
  vpc = true

  tags {
    Name = "web_frontend"
  }
}
