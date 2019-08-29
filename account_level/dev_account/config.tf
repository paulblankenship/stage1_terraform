terraform {
  backend "s3" {}
}

# I intentionally haven't pinned the version.  In real life
# it should be pinned unless you don't mind random changes.
provider "aws" {
  region = "${var.region}"
}
