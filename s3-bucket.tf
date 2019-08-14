resource "aws_s3_bucket" "test-palach-devops" {
  bucket = "test-palach-devops13"
  acl = "private"

  tags = {
    Name        = "file-resource-devops-day13"
    Environment = "Dev"
  }
}
/*
resource "aws_s3_bucket_object" "object" {
  bucket = "test-palach-devops13"
  key    = "web1/index.html"
  source = "./data/web1/index.html"
#  etag = filemd5("./index.html")

  depends_on = [aws_s3_bucket.test-palach-devops]
}

resource "aws_s3_bucket_object" "object2" {
  bucket = "test-palach-devops13"
  key    = "web2/index.html"
  source = "./data/web2/index.html"
#  etag = filemd5("./index.html")

  depends_on = [aws_s3_bucket.test-palach-devops]
}
*/