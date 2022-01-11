# AWS ELB configuration

resource "aws_elb" "koko_elb" {
  name               = "koko-elb"
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
  security_groups    = [aws_security_group.koko_instance_security_group.id, aws_security_group.koko_elb_security_group.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    target              = "HTTP:80/"
    interval            = 60
    timeout             = 5

  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 300
  tags = {
    Name = "terraform-elb"
  }
}
