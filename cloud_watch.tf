# CPU Utilization Alarm per service
module "cpu_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"
  for_each = local.service_keys

  alarm_name          = "ecs-cpu-utilization-${each.key}"
  alarm_description   = "CPU utilization alarm for ECS service ${each.key}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 80  
  period              = 60
  unit                = "Percent"

  namespace   = "AWS/ECS"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  dimensions = {
    ClusterName = module.ecs.cluster_name
    ServiceName = each.key
  }

  alarm_actions = [module.sns_alerts.topic_arn]
  depends_on = [module.ecs]
}

# Memory Utilization Alarm per service
module "memory_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"
  for_each = local.service_keys

  alarm_name          = "ecs-memory-utilization-${each.key}"
  alarm_description   = "Memory utilization alarm for ECS service ${each.key}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 80  
  period              = 60
  unit                = "Percent"

  namespace   = "AWS/ECS"
  metric_name = "MemoryUtilization"
  statistic   = "Average"

  dimensions = {
    ClusterName = module.ecs.cluster_name
    ServiceName = each.key
  }

  alarm_actions = [module.sns_alerts.topic_arn]
  depends_on = [module.ecs]
}

# CPU Utilization Alarm
module "rds_cpu_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = "rds-cpu-utilization-${module.Postgresql_DB.db_instance_identifier}"
  alarm_description   = "CPU Utilization alarm for RDS instance ${module.Postgresql_DB.db_instance_identifier}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 80
  period              = 60
  unit                = "Percent"

  namespace   = "AWS/RDS"
  metric_name = "CPUUtilization"
  statistic   = "Average"
  
  dimensions = {
    DBInstanceIdentifier = module.Postgresql_DB.db_instance_identifier
  }

  alarm_actions = [module.sns_alerts.topic_arn]
}

# Free Storage Space Alarm (in bytes)
module "rds_free_storage_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = "rds-free-storage-space-${module.Postgresql_DB.db_instance_identifier}"
  alarm_description   = "Free Storage Space alarm for RDS instance ${module.Postgresql_DB.db_instance_identifier}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 2147483648  
  period              = 300
  unit                = "Bytes"

  namespace   = "AWS/RDS"
  metric_name = "FreeStorageSpace"
  statistic   = "Average"

  dimensions = {
    DBInstanceIdentifier = module.Postgresql_DB.db_instance_identifier
    
  }

  alarm_actions = [module.sns_alerts.topic_arn]
}

# Read Latency Alarm (in milliseconds)
module "rds_read_latency_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = "rds-read-latency-${module.Postgresql_DB.db_instance_identifier}"
  alarm_description   = "Read Latency alarm for RDS instance ${module.Postgresql_DB.db_instance_identifier}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 100  
  period              = 60
  unit                = "Milliseconds"

  namespace   = "AWS/RDS"
  metric_name = "ReadLatency"
  statistic   = "Average"

  dimensions = {
    DBInstanceIdentifier = module.Postgresql_DB.db_instance_identifier
  }

  alarm_actions = [module.sns_alerts.topic_arn]
}

# Write Latency Alarm (in milliseconds)
module "rds_write_latency_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = "rds-write-latency-${module.Postgresql_DB.db_instance_identifier}"
  alarm_description   = "Write Latency alarm for RDS instance ${module.Postgresql_DB.db_instance_identifier}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 100  
  period              = 60
  unit                = "Milliseconds"

  namespace   = "AWS/RDS"
  metric_name = "WriteLatency"
  statistic   = "Average"

  dimensions = {
    DBInstanceIdentifier = module.Postgresql_DB.db_instance_identifier
  }

  alarm_actions = [module.sns_alerts.topic_arn]
}