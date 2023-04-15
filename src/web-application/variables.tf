variable "environment" {
  description = "Environment name"
  type        = string
}

variable "main_location" {
  description = "Default resources location"
  type        = string
  default     = "West Europe" 
}

variable "second_location" {
  description = "2nd resources location"
  type        = string
  default     = "North Europe"
}

variable "eshopwebapp_ui_plan_tier" {
  description = "E-shop web application UI tier"
  type        = string
}

variable "eshopwebapp_ui_count" {
  description = "E-shop web application UI count"
  type        = number
}

# variable "eshop_ui_web_app_settings" {
#   description = "E-shop web application UI appconfig"
#   type        = map(any)
#   default     = {}
# }

# variable "eshopwebapp_admin_plan_tier" {
#   description = "E-shop admin web application tier"
#   type        = string
# }

# variable "eshop_admin_web_app_settings" {
#   description = "E-shop admin web application appconfig"
#   type        = map(any)
#   default     = {}
# }

# variable "eshoponweb_sqlserver_login"{
#   description = "E-shop sql server admin login"
#   type        = string
# }

# variable "eshoponweb_sqlserver_password"{
#   description = "E-shop sql server admin password"
#   type        = string
# }