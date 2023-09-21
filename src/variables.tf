variable "location" {
  description = "Resource location"
  default     = "ukSouth"
}

variable "location_short" {
  description = "Resource location"
  default     = "uks"
}

variable "project_name" {
  description = "Project name - should be lowercase with no special chars or numbers"
  default     = "myproject"
}

variable "environment" {
  description = "Name of environment to deploy to"
  default     = "dev"
}
