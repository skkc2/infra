resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-statefiles-workhuman"
  acl    = "private"

  versioning {
    enabled = true
  }
}
