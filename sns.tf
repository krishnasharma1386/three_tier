module "sns_alerts" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 6.0"

  name = "${local.name_prefix}-alerts"

  # Build subscriptions from the email list
  subscriptions = {
    for email in var.notification_emails : 
    replace(email, "@.*", "") => {
      protocol = "email"
      endpoint = email
    }
  }

  tags = local.common_tags
}

