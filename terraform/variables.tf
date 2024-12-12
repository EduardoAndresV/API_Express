variable "region" {
  default = "us-east-1"
}

variable "db_name" {
  default = "challengGCV_db"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "C0ntra$3hnA$3gurA"
}

variable "db_instance_class" {
  default = "db.t3.medium"
}

variable "allocated_storage" {
  default = 25
}

variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "8.0"
}

variable "allowed_cidr" {
  default = "10.0.0.0/24" #Ejemplo de CIDR
}