# These are straight forward outputs that the environment TF configs
# we be relying on.  Pretty much IAM roles, SGs, EIPs and AMIs but not
# strictly limited to these things.
# Core resources
output "vpc_id"               { value = "${aws_vpc.main.id}" }
output "subnets_public"       { value = ["${aws_subnet.public.*.id}"] }
output "subnets_private"      { value = ["${aws_subnet.private.*.id}"] }
output "external_access_cidr" { value = "${var.external_access_cidr}" }
output "winjump_eip"          { value = "${aws_eip.winjump.id}" }
output "linjump_eip"          { value = "${aws_eip.linjump.id}" }

# Account wide SGs
output "base_sg"    { value = "${aws_security_group.base_system.id}" }
output "winjump_sg" { value = "${aws_security_group.winjump_external.id}" }
output "linjump_sg" { value = "${aws_security_group.linjump_external.id}" }

# IAM schtuff for later on
output "profile_winjump" { value = "${aws_iam_instance_profile.winjump.id}" }
output "profile_linjump" { value = "${aws_iam_instance_profile.linjump.id}" }
output "profile_ad_core" { value = "${aws_iam_instance_profile.ad-gui.id}" }
output "profile_ad_gui"  { value = "${aws_iam_instance_profile.ad-core.id}" }

# Windows specific things
output "windows_server_ami"      { value = "${var.windows_server_ami}" }
output "windows_server_core_ami" { value = "${var.windows_server_core_ami}" }

# Linux specific things
output "centos_ami" { value = "${var.centos_ami}" }
output "debian_ami" { value = "${var.debian_ami}" }
