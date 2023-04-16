variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Default resources location"
  type        = string
  default     = "West Europe"
}

variable "client_secret" {
  description = "Azure AD client secret"
  type        = string
}
