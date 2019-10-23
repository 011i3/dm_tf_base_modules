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

# ###########################
# # FETCH AMI 
# ########################### 
# data "aws_ami" "dm_base_ami_res" {
#   most_recent = true
#   name_regex  = "^golden"
#   owners      = ["self"]

#   #   filter {
#   #     name   = "name"
#   #     values = ["golden"]
#   #   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   #   filter {
#   #     name   = "owner-alias"
#   #     values = ["golden"]
#   #   }
# }
