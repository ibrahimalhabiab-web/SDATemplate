variable "environment" {
  description = "Environment name: dev or prod. Set in env/<environment>.tfvars."
  type        = string
}

variable "region" {
  description = "Azure region, e.g. uaenorth. Your ADR-0001 decides this; fill it into env/<environment>.tfvars."
  type        = string
}

variable "project_prefix" {
  description = "Short prefix for resource names, e.g. tasreeh-alpha. Fill it into env/<environment>.tfvars."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,16}$", var.project_prefix))
    error_message = "project_prefix must be 3-16 lowercase letters, numbers, or hyphens."
  }
}

variable "sql_admin_login" {
  description = "Bootstrap SQL administrator login. Supply securely during plan/apply; do not commit a value."
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "Bootstrap SQL administrator password. Supply securely during plan/apply; do not commit a value."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.sql_admin_password) >= 16
    error_message = "sql_admin_password must be at least 16 characters."
  }
}

variable "vnet_address_space" {
  description = "Address space for the VNet."
  type        = list(string)
  default     = ["10.30.0.0/16"]
}

variable "app_subnet_prefix" {
  description = "Address prefix for the app subnet (App Service / Functions VNet integration)."
  type        = list(string)
  default     = ["10.30.1.0/24"]
}

variable "pe_subnet_prefix" {
  description = "Address prefix for the private-endpoint subnet (PaaS services reached privately)."
  type        = list(string)
  default     = ["10.30.2.0/24"]
}

locals {
  common_tags = {
    environment = var.environment
    project     = "tasreeh"
    owner       = var.project_prefix
    cost_center = "bootcamp"
  }
}
