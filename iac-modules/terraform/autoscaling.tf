resource "aws_key_pair" "ubuntu" {
  key_name   = "ubuntu"
  public_key = file(var.PUBLIC_KEY)
}

data "aws_availability_zones" "available" {
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# autoscale launch configuration
resource "aws_launch_configuration" "launch_configuration" {
  name            = "autoscaling-launch-configuration"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ubuntu.key_name
  security_groups = [aws_security_group.koko_instance_security_group.id]
  user_data       = "#!/bin/bash\napt-get update" 
  lifecycle {
    create_before_destroy = true
  }
}

# autoscale group
resource "aws_autoscaling_group" "autoscaling_group" {
  name                 = "autoscaling-group"
  availability_zones   = data.aws_availability_zones.available.names
  desired_capacity     = 2
  max_size             = 3
  min_size             = 2
  launch_configuration = aws_launch_configuration.launch_configuration.name
  force_delete         = true
  tag {
    key                 = "Name"
    value               = "custom_koko_instance"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.id
  elb                    = aws_elb.koko_elb.id
}
# autoscaling policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  cooldown               = 60
  policy_type            = "SimpleScaling"
}

# cloudwatch monitor
resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name                = "scale-up-on-cpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 20.0
  alarm_description         = "scale up on cpu utilization"
  insufficient_data_actions = []
  ok_actions                = []

  dimensions = {
    name  = "AutoScalingGroupName"
    value = aws_autoscaling_group.autoscaling_group.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

# define auto descaling policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  cooldown               = 60
  policy_type            = "SimpleScaling"
}

# descale cloudwatch
resource "aws_cloudwatch_metric_alarm" "scale_down_on_cpu_utilization" {
  alarm_name                = "scale-down-on-cpu-utilization"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 10.0
  alarm_description         = "scale down on cpu utilization"
  insufficient_data_actions = []
  ok_actions                = []

  dimensions = {
    name  = "AutoScalingGroupName"
    value = aws_autoscaling_group.autoscaling_group.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}

output "elb" {
  value = aws_elb.koko_elb.dns_name
}
