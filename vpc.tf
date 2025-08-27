#VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name                          = local.aws_vpc_main.vpc_name
  cidr                          = local.aws_vpc_main.vpc_cidr
  azs                           = local.aws_vpc_main.vpc_azs
  private_subnets               = local.aws_vpc_main.vpc_private_subnets
  database_subnets              = local.aws_vpc_main.vpc_private_db_subnets
  public_subnets                = local.aws_vpc_main.vpc_public_subnets
  enable_dns_hostnames          = local.aws_vpc_main.enable_dns_hostnames
  enable_dns_support            = local.aws_vpc_main.enable_dns_support
  enable_nat_gateway            = local.aws_vpc_main.enable_nat_gateway
  single_nat_gateway            = local.aws_vpc_main.single_nat_gateway
  one_nat_gateway_per_az        = local.aws_vpc_main.one_nat_gateway_per_az
  map_public_ip_on_launch       = local.aws_vpc_main.map_public_ip_on_launch
  manage_default_security_group = local.aws_vpc_main.manage_default_security_group

  create_flow_log_cloudwatch_iam_role             = local.aws_vpc_main.create_flow_log_cloudwatch_iam_role
  create_flow_log_cloudwatch_log_group            = local.aws_vpc_main.create_flow_log_cloudwatch_log_group
  enable_flow_log                                 = local.aws_vpc_main.enable_flow_log
  flow_log_cloudwatch_log_group_retention_in_days = local.aws_vpc_main.flow_log_cloudwatch_log_group_retention_in_days
}