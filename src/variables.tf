variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Default resources location"
  type        = string
  default     = "West Europe"
}

variable "eshopwebapp_ui_plan_tier" {
  description = "E-shop web application UI tier"
  type        = string
}

variable "eshop_ui_web_app_settings" {
  description = "E-shop web application UI appconfig"
  type        = map(any)
  default     = {}
}

