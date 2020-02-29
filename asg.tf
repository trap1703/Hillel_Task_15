data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_launch_configuration" "s_launchconfig" {
  name_prefix     = "launchconfig"
  image_id        = "ami-0e8c04af2729ff1bb"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.SGEC2.id]
  key_name        = "testtottoro"
  user_data       = "${file("user-data.web")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "s_autoscaling" {
  name                      = "my_autoscaling"
  vpc_zone_identifier       = ["subnet-0226448e7a17f7c3d", "subnet-0540c728a37ce1fca", "subnet-0be9cd78e9874d405", "subnet-0e8c6cc243fd43fae"]
  launch_configuration      = aws_launch_configuration.s_launchconfig.name
  min_size                  = 2
  max_size                  = 4
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }
}
