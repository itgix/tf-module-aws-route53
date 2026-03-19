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

variable "account_id" {
  description = "AWS account ID used in the CloudWatch log resource policy ARN"
  type        = string
}

variable "enable_query_logging" {
  description = "Enable Route53 query logging to CloudWatch (only for public zones)"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatch log group retention in days"
  type        = number
  default     = 90
}
