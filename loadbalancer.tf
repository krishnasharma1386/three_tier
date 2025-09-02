# Public Application Load Balancer
module "public_alb" {
  source  = "terraform-aws-modules/alb/aws"
  name               = "${local.name_prefix}-public"
  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.public_alb_sg.security_group_id]
  enable_deletion_protection = false
  create_security_group = false
  target_groups = [
    {
      name             = "${local.name_prefix}-web-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = local.common_tags
}

module "private_alb" {
  source  = "terraform-aws-modules/alb/aws"
  name               = "${local.name_prefix}-private"
  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.public_alb_sg.security_group_id]
  enable_deletion_protection = false
  create_security_group = false
  target_groups = [
    {
      name             = "${local.name_prefix}-app-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 30
        matcher             = "200"
        path                = "/ping"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = local.common_tags
}


# Private Application Load Balancer
# module "private_alb" {
#   source  = "terraform-aws-modules/alb/aws"
#   version = "~> 8.0"

#   name               = "${local.name_prefix}-private"
#   load_balancer_type = "application"
#   internal           = true

#   vpc_id          = module.vpc.vpc_id
#   subnets         = module.vpc.public_subnets
#   security_groups = [module.private_alb_sg.security_group_id]

#   target_groups = [
#     {
#       name             = "${local.name_prefix}-app-tg"
#       backend_protocol = "HTTP"
#       backend_port     = 80
#       target_type      = "ip"
#       health_check = {
#         enabled             = true
#         healthy_threshold   = 2
#         interval            = 30
#         matcher             = "200"
#         # path                = "/ping"
#         path                = "/"
#         port                = "traffic-port"
#         protocol            = "HTTP"
#         timeout             = 5
#         unhealthy_threshold = 2
#       }
#     }
#   ]

#   http_tcp_listeners = [
#     {
#       port               = 80
#       protocol           = "HTTP"
#       target_group_index = 0
#     }
#   ]

#   tags = local.aws_ecs.tags
# }
