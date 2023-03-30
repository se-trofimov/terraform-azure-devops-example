variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Default resources location"
  type        = string
  default     = "West Europe"
}

variable "eshoponweb_sqlserver_login"{
  description = "E-shop sql server admin login"
  type        = string
}

variable "eshoponweb_sqlserver_password"{
  description = "E-shop sql server admin password"
  type        = string
}

variable "eshoponweb_sqlserver_sku"{
  description = "E-shop sql server sku"
  type        = string
}

variable "eshoponweb_sqlserver_max_size_gb" {
  description = "E-shop sql server max db size"
  type        = number
}