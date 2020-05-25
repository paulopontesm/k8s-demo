# variables.tf - user settings. For provider settings see config.tf

### project
variable "project_slug" {
  description = "Base project slug, used to name resources"
  type        = string
  default     = "k8sdemo"
}

variable "custom_tags" {
  description = "Map of custom tags to apply to every resource"
  type        = map(string)
  default     = {}
}
