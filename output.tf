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

output "ecs_service" {
  value = module.ecs.services
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
output "sns_alerts_id" {
  value = module.sns_alerts.topic_id
}
output "sns_alerts_arn" {
  value = module.sns_alerts.topic_arn
}
# output "api_id" {
#   description = "The API identifier"
#   value       = module.api_gateway.api_id
# }

# output "api_endpoint" {
#   description = "URI of the API, of the form `https://{api-id}.execute-api.{region}.amazonaws.com` for HTTP APIs and `wss://{api-id}.execute-api.{region}.amazonaws.com` for WebSocket APIs"
#   value       = module.api_gateway.api_endpoint
# }

# output "api_arn" {
#   description = "The ARN of the API"
#   value       = module.api_gateway.api_arn
# }

# output "api_execution_arn" {
#   description = "The ARN prefix to be used in an `aws_lambda_permission`'s `source_arn` attribute or in an `aws_iam_policy` to authorize access to the `@connections` API"
#   value       = module.api_gateway.api_execution_arn
# }