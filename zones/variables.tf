variable "create" {
  description = "Whether to create Route53 zone"
  type        = bool
  default     = true
}

variable "zones" {
  description = "Map of Route53 zone parameters"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags added to all zones. Will take precedence over tags from the 'zones' variable"
  type        = map(any)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch log group retention in days (maximum 365)"
  type        = number
  default     = 365
}
