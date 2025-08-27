locals {
  name_prefix = "${var.project_name}-${var.environment}"
  ports = {
    http  = 80
    https = 443
    ssh   = 22
    app   = 8080
    mysql = 3306
  }

  aws_vpc_main_defaults = {
    project_name                                  = var.project_name
    environment                                   = var.environment
    vpc_name                                      = "${var.project_name}-${var.environment}-vpc"
    create_vpc                                    = true
    vpc_cidr                                      = "10.2.0.0/16"
    vpc_azs                                       = ["ap-south-1a", "ap-south-1b"]
    vpc_private_subnets                           = ["10.2.128.0/20", "10.2.144.0/20"]
    vpc_private_db_subnets                        = ["10.2.80.0/20","10.2.96.0/20"]
    vpc_public_subnets                            = ["10.2.0.0/20", "10.2.16.0/20"]
    enable_dns_hostnames                          = true
    enable_dns_support                            = true
    enable_nat_gateway                            = true
    single_nat_gateway                            = true
    one_nat_gateway_per_az                        = false
    map_public_ip_on_launch                       = false
    manage_default_security_group                 = false
    create_flow_log_cloudwatch_iam_role           = true
    create_flow_log_cloudwatch_log_group          = true
    enable_flow_log                               = true
    flow_log_cloudwatch_log_group_retention_in_days = 30
  }
  aws_vpc_main = merge(local.aws_vpc_main_defaults, {})

  aws_ecs_defaults = {
    project_name     = var.project_name
    environment      = var.environment
    cluster_name     = "${var.project_name}-${var.environment}-ecs"

    create_cloudwatch_log_group            = true
    cloudwatch_log_group_retention_in_days = 30
    cloudwatch_log_group_kms_key_id        = null

    cluster_configuration = {
      execute_command_configuration = {
        logging = "OVERRIDE"
        log_configuration = {
          cloud_watch_log_group_name = "/aws/ecs/${var.project_name}-${var.environment}"
        }
      }
    }

    fargate_capacity_providers = {
      FARGATE = {
        default_capacity_provider_strategy = {
          weight = 100
        }
      }
    }
    tags = {
      Terraform   = "true"
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
    aws_ecs = merge(local.aws_ecs_defaults, {})
}

locals {
  bucket_name = "s3-bucket-${random_pet.this.id}"
  region      = var.aws_region
}

locals {
  domain_name = "terraform-aws-modules.modules.tf" # trimsuffix(data.aws_route53_zone.this.name, ".")
  subdomain   = "cdn"
}
