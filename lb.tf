resource "aws_elb" "elb" {
  name            = "lb"
  subnets         = ["subnet-0226448e7a17f7c3d", "subnet-0540c728a37ce1fca", "subnet-0be9cd78e9874d405", "subnet-0e8c6cc243fd43fae"]
  security_groups = [aws_security_group.SGloadBalance.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
  tags = {
    Name = "s elb"
  }
}
