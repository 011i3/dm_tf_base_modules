data "template_file" "dm_fe_bootstrap_ds" {
  template = "${file("${path.module}/templates/bootstrap.sh")}"
}

data "template_cloudinit_config" "dm_fe_bootstrap_inst_res" {
  gzip          = "true"
  base64_encode = "true"

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.dm_fe_bootstrap_ds.rendered}"
  }
}

resource "aws_launch_configuration" "dm_fe_lc_res" {
  name_prefix                 = "web01_${var.environment}_"
#   image_id                    = "${data.aws_ami.dm_base_ami_res.id}"
  image_id                    = "ami-3548444c"
  instance_type               = "${var.web_inst_type}"
  key_name                    = "dm-kliuch"
  enable_monitoring           = true
  security_groups             = ["${aws_security_group.dm_fe_sg_res.id}"]
  associate_public_ip_address = true

  user_data = "${data.template_cloudinit_config.dm_fe_bootstrap_inst_res.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "dm_fe_asg_res" {
  name                 = "${aws_launch_configuration.dm_fe_lc_res.name}-asg"
  min_size             = "1"
  max_size             = "1"
  desired_capacity     = "1"
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.dm_fe_lc_res.name}"
  #vpc_zone_identifier  = "${aws_subnet.dm_sn_pub_res.*.id}"
  vpc_zone_identifier  = "${data.terraform_remote_state.dm_vpc_state_ds.outputs.pub_sn_id_otp}"

    tags = [
      {
        key                = "Name"
        value              = "web-01"
        propagate_at_launch = true
      },
    ]

  lifecycle {
    create_before_destroy = true
  }
}

