resource "aws_launch_configuration" "web" {
  //  name            = "WebServer-Highly-Available-LC"
  name_prefix     = "WebServer-Highly-Available-LC-"
  image_id        = data.aws_ami.ami-linux2.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.public_sg.id]
  user_data       = file("./data/user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 1
  max_size             = 3
  desired_capacity    = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_subnet.public1.id, aws_subnet.public2.id]
  load_balancers       = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name   = "WebServer in ASG"
      Owner  = "Alex"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
//  availability_zones = [data.aws_availability_zones.vailability_zones.names[0], data.aws_availability_zones.vailability_zones.names[1]]
  subnets = [aws_subnet.public1.id, aws_subnet.public2.id]
  security_groups    = [aws_security_group.public_sg.id]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "WebServer-Highly-Available-ELB"
  }
}
