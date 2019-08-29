# This is needed due to Terraform's interpolation issues with backends
# This should also be modified to match your env
encrypt = "true"
bucket  = "dev-terraform"
region  = "us-west-1"
key     = "envs/dev_account/us-west-1/terraform.tfstate"
