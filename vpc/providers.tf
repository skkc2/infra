provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-statefiles-workhuman"
    key            = "terraform.tfstate"
    region         = "eu-west-1"

  }
}
