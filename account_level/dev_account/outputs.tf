# These are straight forward outputs that the environment TF configs
# we be relying on.  Pretty much IAM roles, SGs, EIPs and AMIs but not
# strictly limited to these things.
# Core resources
output "vpc_id"               { value = "${aws_vpc.main.id}" }
output "subnets_public"       { value = ["${aws_subnet.public.*.id}"] }
output "subnets_private"      { value = ["${aws_subnet.private.*.id}"] }
output "external_access_cidr" { value = "${var.external_access_cidr}" }
output "web_frontend_eip"     { value = "${aws_eip.web_frontend.id}" }

# Account wide SGs
output "web_frontend_sg" { value = "${aws_security_group.web_frontend_external.id}" }
output "app_backend_sg"  { value = "${aws_security_group.app_backend_external.id}" }

# IAM schtuff for later on
output "profile_web_frontend" { value = "${aws_iam_instance_profile.web_frontend.id}" }
output "profile_app_backend"  { value = "${aws_iam_instance_profile.app_backend.id}" }

# Windows specific things
output "windows_server_ami"      { value = "${var.windows_server_ami}" }
output "windows_server_core_ami" { value = "${var.windows_server_core_ami}" }

# Linux specific things
output "centos_ami" { value = "${var.centos_ami}" }
output "debian_ami" { value = "${var.debian_ami}" }
