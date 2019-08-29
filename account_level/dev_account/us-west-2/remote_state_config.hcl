# This is needed due to Terraform's interpolation issues with backends
# I recommend 'some_directory' be a part of whatefver naming convention
# your organization has.
encrypt = "true"
bucket  = "infra-terraform"
region  = "us-west-1"
key     = "some_directory/terraform.tfstate"
