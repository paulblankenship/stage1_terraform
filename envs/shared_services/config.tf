terraform {
  backend "s3" {}
}

data "terraform_remote_state" "account" {
  backend = "s3"

  config {
    bucket  = "${var.terraform_state_s3bucket}"
    key     = "${var.terraform_account_outputs_key}"
    region  = "${var.terraform_state_s3region}"
  }
}

provider "aws" {
  region  = "${var.region}"
}
