# S3 for static hosting
module "s3_one" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"
  bucket_prefix = "s3-one-"
  force_destroy = true
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_one.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
  depends_on = [module.cloudfront]
}

# provisioner "local_exec"{
#     command = "aws s3 cp ~/~/test_files/web/index.html ${module.s3_one.s3_bucket_bucket_id}"
#   }