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
 