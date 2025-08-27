output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_alb_dns" {
  value = module.public_alb.lb_dns_name
}

output "private_alb_dns" {
  value = module.private_alb.lb_dns_name
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}

output "service_discovery_namespace" {
  value = aws_service_discovery_private_dns_namespace.be_ecs.name
}


output "cloudfront_url" {
  value = module.cloudfront.cloudfront_distribution_domain_name
}

output "s3_dns" {
    value = module.s3_one.s3_bucket_bucket_domain_name
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.Postgresql_DB.db_instance_address
}

