#create bucker 

resource "aws_s3_bucket" "mybucket"{
    bucket = "mys3bucketforstatefile-1226"
}
resource "aws_s3_bucket_versioning" "mybuckeversion" {
  bucket = aws_s3_bucket.mybucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "mybucketenc" {
         bucket = aws_s3_bucket.mybucket.id
        rule {
            apply_server_side_encryption_by_default {
            sse_algorithm     = "AES256"
            }
        }
}
#create dynamo_db

resource "aws_dynamodb_table" "state-lock" {
  name = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name="LockID"
    type = "S"
  }
} 