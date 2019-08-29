resource "aws_instance" "winjump" {
  count                       = "${var.winjump_instance_count}"
  ami                         = "${data.terraform_remote_state.account.windows_server_ami}"
  instance_type               = "${var.winjump_instance_type}"
  subnet_id                   = "${element(data.terraform_remote_state.account.subnets_public, count.index)}"
  key_name                    = "${var.ssh_keypair_name}"
  iam_instance_profile        = "${data.terraform_remote_state.account.profile_winjump}"

  vpc_security_group_ids = ["${data.terraform_remote_state.account.winjump_sg}",
    "${data.terraform_remote_state.account.base_sg}"
  ]

  tags {
    Name        = "${var.environment}-winjump-${format("%02d", count.index+1)}"
    environment = "${var.environment}"
  }

  lifecycle {
    ignore_changes = ["ami", "key_name"]
  }
}

resource "aws_eip_association" "winjump" {
  instance_id   = "${element(aws_instance.winjump.*.id, count.index)}"
  allocation_id = "${data.terraform_remote_state.account.winjump_eip}"
}

# In case we end up with Route53
#resource "aws_route53_record" "winjump-internal" {
#  count   = "${var.winjump_instance_count}"
#  zone_id = "${data.terraform_remote_state.account.int_dns_zone_id}"
#  name    = "${var.environment}-winjump-i${format("%02d", count.index+1)}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${element(aws_instance.winjump.*.private_ip, count.index)}"]
#}

#resource "aws_route53_record" "winjump-external" {
#  count   = "${var.winjump_instance_count}"
#  zone_id = "${data.terraform_remote_state.account.ext_dns_zone_id}"
#  name    = "${var.environment}-winjump-${format("%02d", count.index+1)}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${element(aws_instance.winjump.*.public_ip, count.index)}"]
#}
