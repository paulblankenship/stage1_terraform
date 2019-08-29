resource "aws_instance" "web_frontend" {
  count                       = "${var.web_frontend_instance_count}"
  ami                         = "${data.terraform_remote_state.account.windows_server_ami}"
  instance_type               = "${var.web_frontend_instance_type}"
  subnet_id                   = "${element(data.terraform_remote_state.account.subnets_public, count.index)}"
  key_name                    = "${var.ssh_keypair_name}"
  iam_instance_profile        = "${data.terraform_remote_state.account.profile_web_frontend}"

  vpc_security_group_ids = ["${data.terraform_remote_state.account.web_frontend_sg}",
    "${data.terraform_remote_state.account.base_sg}"
  ]

  tags {
    Name        = "${var.environment}-web_frontend-${format("%02d", count.index+1)}"
    environment = "${var.environment}"
  }

  lifecycle {
    ignore_changes = ["ami", "key_name"]
  }
}

resource "aws_eip_association" "web_frontend" {
  instance_id   = "${element(aws_instance.web_frontend.*.id, count.index)}"
  allocation_id = "${data.terraform_remote_state.account.web_frontend_eip}"
}

# In case we end up with Route53
#resource "aws_route53_record" "web_frontend-internal" {
#  count   = "${var.web_frontend_instance_count}"
#  zone_id = "${data.terraform_remote_state.account.int_dns_zone_id}"
#  name    = "${var.environment}-web_frontend-i${format("%02d", count.index+1)}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${element(aws_instance.web_frontend.*.private_ip, count.index)}"]
#}

#resource "aws_route53_record" "web_frontend-external" {
#  count   = "${var.web_frontend_instance_count}"
#  zone_id = "${data.terraform_remote_state.account.ext_dns_zone_id}"
#  name    = "${var.environment}-web_frontend-${format("%02d", count.index+1)}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${element(aws_instance.web_frontend.*.public_ip, count.index)}"]
#}
