vpc_id                  = "vpc-0b04b0b64835ca5d1"
private_subnet_id       = ["subnet-04dd78b4152a33ca9", "subnet-07c1a232a0b7232e6", "subnet-07f9b3fba2c075a4d"]
public_subnet_id        = ["subnet-08282ed11d53a7c56", "subnet-0eb171009097fbb9b", "subnet-040d176c5d5c25246"]
db_private_subnet_id    = ["subnet-00d3dec067f99546a", "subnet-0b61732e6830a9a5b", "subnet-099f71a392d709bbf"]
instance_count          = 1
instance_ami            = "ami-0d421d84814b7d51c"
instance_type           = "t3.medium"
rds_allocated_storage   = 20
rds_storage_type        = "gp2"
rds_engine              = "postgres"
rds_engine_version      = "16.0"
rds_instance_class      = "db.t3.medium"
rds_db_name             = "nginx"
rds_username            = "saikiran"
rds_password            = "updated123456"
rds_publicly_accessible = false
