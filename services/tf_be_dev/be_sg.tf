resource "aws_security_group" "dm_be_sg_res" {
  name_prefix = "BACKEND SG"
  description = "Allow all http/https ${data.terraform_remote_state.dm_vpc_state_ds.outputs.vpc_cidr_otp} VPC"
  vpc_id      = "${data.terraform_remote_state.dm_vpc_state_ds.outputs.vpc_id_otp}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "dm_be_sg_ssh_res" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = "${concat(data.terraform_remote_state.dm_vpc_state_ds.outputs.pub_sn_cidr_otp, data.terraform_remote_state.dm_vpc_state_ds.outputs.priv_sn_cidr_otp)}"
  security_group_id = "${aws_security_group.dm_be_sg_res.id}"
}

resource "aws_security_group_rule" "dm_app_sg_rl_res" {
  type              = "ingress"
  from_port         = "8080"
  to_port           = "8080"
  protocol          = "tcp"
  cidr_blocks       = "${concat(data.terraform_remote_state.dm_vpc_state_ds.outputs.priv_sn_cidr_otp)}"
  security_group_id = "${aws_security_group.dm_be_sg_res.id}"
}

resource "aws_security_group_rule" "dm_be_egress_res" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.dm_be_sg_res.id}"
}
