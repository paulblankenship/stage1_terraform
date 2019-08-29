# Specifics for Terraform state storage
# these override the defaults in the 'above' configurations
# to the specifics of the one we would like to built our VPC(s) in
terraform_state_s3key  = "aiuw1/terraform.tfstate"

availability_zones = ["us-west-1c", "us-west-1b"]
# Note: availability_zone_names must match above, used for tags
availability_zone_names = ["C", "B"]

name = "resource_naming"
cidr_prefix = "10.2"
region = "us-west-1"

windows_server_ami = "ami-12345"
windows_server_core_ami = "ami-54321"
centos_ami = "ami-67890"
debian_ami = "ami-09876"
