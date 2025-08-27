resource "random_pet" "this" {
  length = 2
}


# Public ALB SG (Internet -> Web)
module "public_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${local.name_prefix}-public-alb"
  description = "Security group for Public ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = local.aws_ecs.tags
}

# Private ALB SG (only from Web/ECS)
module "private_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${local.name_prefix}-private-alb"
  description = "Security group for Private ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = module.public_alb_sg.security_group_id
    }
  ]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = local.aws_ecs.tags
}

# # ECS Web Service SG
# module "ecs_web_sg" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "~> 5.0"

#   name        = "${local.name_prefix}-web-svc"
#   description = "SG for ECS Web Service"
#   vpc_id      = module.vpc.vpc_id

#   ingress_with_source_security_group_id = [
#     {
#       rule                     = "http-80-tcp"
#       source_security_group_id = module.public_alb_sg.security_group_id
#     }
#   ]

#   egress_rules       = ["all-all"]
#   egress_cidr_blocks = ["0.0.0.0/0"]

#   tags = local.aws_ecs.tags
# }

# # ECS App Service SG
# module "ecs_app_sg" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "~> 5.0"

#   name        = "${local.name_prefix}-app-svc"
#   description = "SG for ECS App Service"
#   vpc_id      = module.vpc.vpc_id

#   ingress_with_source_security_group_id = [
#     {
#       rule                     = "http-8080-tcp"
#       source_security_group_id = module.private_alb_sg.security_group_id
#     },
#     {
#       rule                     = "http-8080-tcp"
#       source_security_group_id = module.ecs_web_sg.security_group_id
#     }
#   ]

#   egress_rules       = ["all-all"]
#   egress_cidr_blocks = ["0.0.0.0/0"]

#   tags = local.aws_ecs.tags
# }





