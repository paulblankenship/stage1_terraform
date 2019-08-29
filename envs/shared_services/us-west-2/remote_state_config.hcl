# This is needed due to Terraform's interpolation issues with backends
# This should also be modified to match your env
encrypt = "true"
bucket  = "infra-terraform"
region  = "us-west-1"
key     = "envs/shared_services/us-west-2/terraform.tfstate"
