# service discovery
resource "aws_service_discovery_private_dns_namespace" "be_ecs" {
  name        = "${local.name_prefix}.local"
  description = "Private DNS namespace for ${local.name_prefix}"
  vpc         = module.vpc.vpc_id
  tags        = local.common_tags
}


module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 6.0"
  

  cluster_name = local.aws_ecs.cluster_name
  cluster_configuration = local.aws_ecs.cluster_configuration

  create_cloudwatch_log_group            = local.aws_ecs.create_cloudwatch_log_group
  cloudwatch_log_group_name              = "/aws/ecs/${local.name_prefix}"
  cloudwatch_log_group_retention_in_days = local.aws_ecs.cloudwatch_log_group_retention_in_days

  # fargate_capacity_providers = local.aws_ecs.fargate_capacity_providers

  # services now come cleanly from locals
  services = {
      web = {
        cpu    = 256
        memory = 512
        enable_execute_command = true

        container_definitions = {
          web = {
            cpu       = 256
            memory    = 512
            essential = true
            image     = "503515996494.dkr.ecr.ap-south-1.amazonaws.com/web-service"
            readonlyRootFilesystem = false
            "portMappings": [
              {
                "name": "web",
                "containerPort": 80,
                "protocol": "tcp"
              }
            ]
            log_configuration = {
              logDriver = "awslogs"
              options = {
                awslogs-group = "/aws/ecs/${local.name_prefix}"
                awslogs-region = data.aws_region.current.id
                awslogs-stream-prefix = "web"
              }
            }
          }
        }

        service_connect_configuration = {
          namespace = aws_service_discovery_private_dns_namespace.be_ecs.arn
          service = [{
            client_alias = {
              port  = 80
              dns_name = "web"
            }
            port_name = "web"
            discovery_name = "web"
          }]
        }


        load_balancer = {
          service = {
            target_group_arn = element(module.public_alb.target_group_arns, 0)
            container_name   = "web"
            container_port   = 80
            port_name       = "web"
          }
        }

        subnet_ids      = module.vpc.private_subnets
        security_group_ingress_rules = {
            alb_3000 = {
            description = "Service port"
            from_port = local.ports.http
            ip_protocol = "tcp"
            referenced_security_group_id = module.public_alb_sg.security_group_id
            }
        }
        security_group_egress_rules = {
            all = {
            ip_protocol = "-1"
            cidr_ipv4   = "0.0.0.0/0"
            }
        }
      }

      app = {
        cpu    = 256
        memory = 512
        enable_execute_command = true


        container_definitions = {
          app = {
            cpu       = 256
            memory    = 512
            essential = true
            image = "503515996494.dkr.ecr.ap-south-1.amazonaws.com/app-service"
            readonlyRootFilesystem = false
            "portMappings": [
              {
                "name": "app",
                "containerPort": 80,
                "protocol": "tcp"
              }
            ]
            log_configuration = {
              logDriver = "awslogs"
              options = {
                awslogs-group = "/aws/ecs/${local.name_prefix}"
                awslogs-region = data.aws_region.current.id
                awslogs-stream-prefix = "app"
              }
            }
          }
        }

        service_connect_configuration = {
          namespace = aws_service_discovery_private_dns_namespace.be_ecs.arn
          service = [{
            client_alias = {
              port = 80
              dns_name = "app"
            }
            port_name      = "app"
            discovery_name = "app"
          }]
        }


        load_balancer = {
          service = {
            target_group_arn = element(module.private_alb.target_group_arns, 0)
            container_name   = "app"
            container_port   = 80
            port_name       = "app"
          }
        }

        subnet_ids      = module.vpc.private_subnets
        security_group_ingress_rules = {
            alb_3000 = {
            description = "Service port"
            from_port = local.ports.http
            ip_protocol = "tcp"
            referenced_security_group_id = module.public_alb_sg.security_group_id
            }
        }
        security_group_egress_rules = {
            all = {
            ip_protocol = "-1"
            cidr_ipv4   = "0.0.0.0/0"
            }
        }
      }
    }
 

  tags = local.common_tags
}

