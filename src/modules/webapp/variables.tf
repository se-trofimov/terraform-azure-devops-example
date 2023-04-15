variable "webapp_name" {
  description = "Web application name"
  type        = string
}

variable "resource_group_name" {
  description = "Web application resource group name"
  type        = string
}

variable "webapp_plan_tier" {
  description = "Web application SKU"
  type        = string
}

variable "webapp_location" {
  description = "Web application location"
  type        = string
}

variable "webapp_settings" {
  description = "Web application appconfig"
  type        = map(any)
  default     = {}
}

variable "webapp_slots_count" {
  description = "Web application deployment slots count"
  type        = number
  default     = 0
}

variable "identity_ids" {
  description = "Web application managed identity ids"
  type        = list(string)
  default     = []
}
