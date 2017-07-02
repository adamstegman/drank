provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "drank" {
  bucket = "water-wars.adamstegman.com"
  acl = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}
