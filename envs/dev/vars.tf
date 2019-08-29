# These are specifically used for the data source state, not for backend
# though they will and and most likely should be the same.
variable "terraform_state_s3bucket"      { default = "dev-terraform" }
variable "terraform_state_s3region"      { default = "us-west-1" }
variable "terraform_account_outputs_key" { default = "" }

variable "environment" { default = "infrastructure" }
variable "region"      { default = "us-west-1" }

variable "ssh_keypair_name" { default = "terraform" }

variable "web_frontend_instance_count" { default = "1" }
variable "web_frontend_instance_type"  { default = "t2.large" }
variable "app_backend_instance_count" { default = "1" }
variable "app_backend_instance_type"  { default = "t2.small" }
