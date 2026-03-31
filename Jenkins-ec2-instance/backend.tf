#create bucker 

resource "aws_s3_bucket" "mybucket"{
    bucket = "Mys3bucketforstatefile"
    versioning{
        enabled = true 
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

resource "aws_dynamodb_table" "statelock" {
  name = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LOCKID"
  attribute {
    name="LOCKID"
    type = "s"
  }
}