#############################################################################
# Fetch resources from VPC state file: exposed api 
# - data
# - terraform_remote_state
# - https://www.terraform.io/docs/providers/terraform/d/remote_state.html
#############################################################################

data "terraform_remote_state" "dm_vpc_state_ds" {
  backend = "s3"

  config = {
    bucket = "dm-vpc-states"
    key    = "dm_arci_finale/terraform.tfstate"
    region = "${var.aws_region}"
  }
}
