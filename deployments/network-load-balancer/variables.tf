variable "nlb_config" {
  type = object({
    name        = string
    internal    = string
    environment = string
    subnet      = string
    nlb_vpc_id  = string
  })
  description = "Configuration for the network load balancer."
}

variable "forwarding_config" {
  type        = map(string)
  description = "Port forwarding configuration for the network load balancer."
}

variable "tg_config" {
  type = object({
    name                  = string
    target_type           = string
    health_check_protocol = string
    tg_vpc_id             = string
    target_id1            = string
  })
  description = "Configuration for the target group."
}
