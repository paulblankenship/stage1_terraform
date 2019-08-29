# These are all either sane defaults, or empty so terraform doesn't
# complain that it can't find a variable.  The empty ones will usually
# be overridden or we do not care.
variable "terraform_state_s3bucket"      { default = "infra-terraform" }
variable "terraform_state_s3region"      { default = "us-west-1" }
variable "terraform_state_s3key"         { default = "" }

variable "availability_zones" {
  description = "List of the availabiity zones to build subnets in"
  default     = ["us-west-1c", "us-west-1b"]
}

variable "name" {
  default = ""
}

variable "cidr_prefix" {
  description = "First two octets of the CIDR block to be used for this VPC"
  default     = ""
}

variable "availability_zone_names" {
  description = "Names/abbreviations for each availability zone to be used in subnet names, etc (NOTE: must have the same number of entries as are in availability_zones!)"
  default     = ["C", "B"]
}

variable "region" { default = "" }

variable "windows_server_ami"      { default = "" }
variable "windows_server_core_ami" { default = "" }
variable "centos_ami"              { default = "" }
variable "debian_ami"              { default = "" }

variable "external_access_cidr" {
    description = "Network addresses/netblocks (in CIDR notation) which are allowed to access resources in this account from outside"
    default = [
      "127.0.0.1/32" # Pupulate this with legit IP CIDRs
    ]
}
