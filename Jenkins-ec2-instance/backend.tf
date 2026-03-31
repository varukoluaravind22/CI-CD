#create bucker 

terraform {
  backend "s3" {
    bucket = "Mys3bucketforstatefile"
    versioning{
        enabled = true 
    }
    server_side_encrytion_configuration{
        rule{
            apply_server_side_encryption_by_default {
                sse_algorithm     = "AES256"
           }
        }
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