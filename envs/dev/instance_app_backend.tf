resource "aws_instance" "app_backend" {
  count                       = "${var.app_backend_instance_count}"
  ami                         = "${data.terraform_remote_state.account.centos_ami}"
  instance_type               = "${var.app_backend_instance_type}"
  subnet_id                   = "${element(data.terraform_remote_state.account.subnets_public, count.index)}"
  key_name                    = "${var.ssh_keypair_name}"
  iam_instance_profile        = "${data.terraform_remote_state.account.profile_app_backend}"

  vpc_security_group_ids = ["${data.terraform_remote_state.account.app_backend_sg}",
    "${data.terraform_remote_state.account.base_sg}"
  ]

  tags {
    Name        = "${var.environment}-app_backend-${format("%02d", count.index+1)}"
    environment = "${var.environment}"
  }

  lifecycle {
    ignore_changes = ["ami", "key_name"]
  }
}

# In case we end up with Route53
#resource "aws_route53_record" "app_backend-internal" {
#  count   = "${var.app_backend_instance_count}"
#  zone_id = "${data.terraform_remote_state.account.int_dns_zone_id}"
#  name    = "${var.environment}-app_backend-i${format("%02d", count.index+1)}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${element(aws_instance.app_backend.*.private_ip, count.index)}"]
#}

#resource "aws_route53_record" "app_backend-external" {
#  count   = "${var.app_backend_instance_count}"
#  zone_id = "${data.terraform_remote_state.account.ext_dns_zone_id}"
#  name    = "${var.environment}-app_backend-${format("%02d", count.index+1)}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${element(aws_instance.app_backend.*.public_ip, count.index)}"]
#}
