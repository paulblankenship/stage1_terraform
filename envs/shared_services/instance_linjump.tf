resource "aws_instance" "linjump" {
  count                       = "${var.linjump_instance_count}"
  ami                         = "${data.terraform_remote_state.account.centos_ami}"
  instance_type               = "${var.linjump_instance_type}"
  subnet_id                   = "${element(data.terraform_remote_state.account.subnets_public, count.index)}"
  key_name                    = "${var.ssh_keypair_name}"
  iam_instance_profile        = "${data.terraform_remote_state.account.profile_linjump}"

  vpc_security_group_ids = ["${data.terraform_remote_state.account.linjump_sg}",
    "${data.terraform_remote_state.account.base_sg}"
  ]

  tags {
    Name        = "${var.environment}-linjump-${format("%02d", count.index+1)}"
    environment = "${var.environment}"
  }

  lifecycle {
    ignore_changes = ["ami", "key_name"]
  }
}

resource "aws_eip_association" "linjump" {
  instance_id   = "${element(aws_instance.linjump.*.id, count.index)}"
  allocation_id = "${data.terraform_remote_state.account.linjump_eip}"
}

# In case we end up with Route53
#resource "aws_route53_record" "linjump-internal" {
#  count   = "${var.linjump_instance_count}"
#  zone_id = "${data.terraform_remote_state.account.int_dns_zone_id}"
#  name    = "${var.environment}-linjump-i${format("%02d", count.index+1)}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${element(aws_instance.linjump.*.private_ip, count.index)}"]
#}

#resource "aws_route53_record" "linjump-external" {
#  count   = "${var.linjump_instance_count}"
#  zone_id = "${data.terraform_remote_state.account.ext_dns_zone_id}"
#  name    = "${var.environment}-linjump-${format("%02d", count.index+1)}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${element(aws_instance.linjump.*.public_ip, count.index)}"]
#}
