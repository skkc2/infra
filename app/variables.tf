variable "vpc_id" {
  type = string
}
variable "public_subnet_id" {
  type = list(string)
}
variable "private_subnet_id" {
  type = list(string)
}
variable "db_private_subnet_id" {
  type = list(string)
}
variable "instance_count" {
  default = 1
}

variable "instance_ami" {
  type = string
}
variable "rds_port" {
  default = 5432
}
variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "rds_allocated_storage" {
  default = 20
}

variable "rds_storage_type" {
  default = "gp2"
  type    = string
}

variable "rds_engine" {
  default = "postgres"
  type    = string
}

variable "rds_engine_version" {
  default = "16.0"
  type    = string
}

variable "rds_instance_class" {
  default = "db.t2.micro"
  type    = string
}

variable "rds_db_name" {
  type = string
}

variable "rds_username" {
  default = "admin"
  type    = string
}

variable "rds_password" {
  default = "password"
  type    = string
}

variable "rds_publicly_accessible" {
  default = false
}
