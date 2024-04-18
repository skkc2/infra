variable "region" {
  description = "AWS region"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "db_private_subnet_cidr_blocks" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
}

# variable "backend_bucket" {
#   description = "Name of the S3 bucket to store Terraform state file"
# }

# variable "dynamodb_table" {
#   description = "Name of the DynamoDB table for Terraform state locking"
# }

variable "region_availability_zones" {
  description = "Availability zones in the region"
  type        = list(string)
}