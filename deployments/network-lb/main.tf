locals {
  subnet_a = "subnet-0ccd55e85904b3ea1"
}

resource "aws_lb" "main-entry-door" {
  name                       = "main-entry-door"
  load_balancer_type         = "network"
  subnets                    = [lookup(var.nlb_config, "subnet")]
  enable_deletion_protection = false
  ip_address_type            = "ipv4"

}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.main-entry-door.arn
  for_each          = var.forwarding_config
  port              = each.key
  protocol          = each.value
  default_action {
    target_group_arn = "${aws_lb_target_group.tg[each.key].arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "tg" {
  for_each             = var.forwarding_config
  name                 = "${lookup(var.nlb_config, "environment")}-tg-${lookup(var.tg_config, "name")}-${each.key}"
  port                 = each.key
  protocol             = each.value
  vpc_id               = lookup(var.tg_config, "tg_vpc_id")
  target_type          = lookup(var.tg_config, "target_type")
  deregistration_delay = 90
  health_check {
    interval            = 60
    port                = each.value != "TCP_UDP" ? each.key : 80
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "tga1" {
  for_each         = var.forwarding_config
  target_group_arn = "${aws_lb_target_group.tg[each.key].arn}"
  port             = each.key
  target_id        = lookup(var.tg_config, "target_id1")
}

variable "nlb_config" {
  default = {
    name        = "main-entry-door"
    internal    = "false"
    environment = "test"
    subnet      = "subnet-0ccd55e85904b3ea1"
    nlb_vpc_id  = "vpc-026aaa3e32a5b483c"
  }
}

variable "tg_config" {
  default = {
    name                  = "test-nlb-tg"
    target_type           = "instance"
    health_check_protocol = "TCP"
    tg_vpc_id             = "vpc-026aaa3e32a5b483c"
    target_id1            = "i-00f2e99983f03fc36"
  }
}

variable "forwarding_config" {
  default = {
    80  = "TCP"
    443 = "TCP" # and so on
  }
}