# CloudFront
module "cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"
  comment = "TF module for Cloudfront"
  enabled = true
  is_ipv6_enabled = true
  price_class = "PriceClass_All"
  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
        description = "CloudFront access to S3"
        origin_type = "s3"
        signing_behavior = "always"
        signing_protocol = "sigv4"
    }
  }
  default_root_object = "index.html"
  origin = {
    s3_oac = {
        domain_name = module.s3_one.s3_bucket_bucket_regional_domain_name
        origin_access_control = "s3_oac"
    }
  }

  default_cache_behavior = {
    target_origin_id = "s3_oac"
    viewer_protocol_policy = "allow-all"
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
  }

  geo_restriction = {
    restriction_type = "none"
    locations = []
  }

  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  tags = {
    project = "cf-s3"
    environment = "dev"
    name = "cf-s3-dev-cloudfront"
  }
}
