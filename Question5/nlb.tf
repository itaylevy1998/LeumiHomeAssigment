resource "aws_lb" "q5-nlb" {
  name               = "q5-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public-subnet.id]
  security_groups = [aws_security_group.nlb-sg.id]
}

resource "aws_lb_target_group" "q5-nlb-tg" {
  name     = "q5-nlb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "q5-nlb-tg-attachment" {
  target_group_arn = aws_lb_target_group.q5-nlb-tg.arn
  target_id        = aws_instance.test-ec2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.q5-nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.q5-nlb-tg.arn
  }
}