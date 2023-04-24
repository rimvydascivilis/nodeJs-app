resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "nodejs-app-codepipeline-bucket"
  force_destroy = true
}
