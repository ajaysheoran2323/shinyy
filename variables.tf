variable "region" {
  default = "us-east-1"
}
variable "rds_identifier" {
  description = "identifier"
  default     = "shiny"
}
variable "shiny_image" {
  default = "ajaysheoran2323/shiny-app:latest"
}

variable "rds_instance_type" {
  description = "Instance type for the RDS database"
  default = "db.t2.micro"
}
variable "rds_storage_type" {
  description = "db storage type"
  default     = "gp2"
}
variable "rds_allocated_storage" {
  description = "db allocated storage"
  default     = 5
}
variable "rds_engine" {
  description = "type of db engine"
  default     = "postgres"
}
variable "rds_engine_version" {
  description = "db engine version"
  default     = "12"
}
variable "rds_database_name" {
  description = "db worker name"
  default     = "shiny"
}
variable "rds_username" {
  description = "db username"
  default     = "postgres"
}
variable "rds_password" {
  description = "db password"
  default     = "shinyadmin"
}
variable "rds_final_snapshot_identifier" {
  description = "db snap"
  default     = "shiny-snap"
}
