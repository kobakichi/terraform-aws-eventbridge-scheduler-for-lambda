# EventBridge Scheduler Module Variables

variable "schedule_name" {
  description = "Name of the EventBridge Scheduler schedule"
  type        = string
}



variable "schedule_expression" {
  description = "Schedule expression (e.g., rate(5 minutes), cron(0 12 * * ? *))"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the target Lambda function"
  type        = string
}

variable "lambda_input" {
  description = "Input data to pass to the Lambda function"
  type        = map(any)
  default     = {}
}

variable "enable_input" {
  description = "Whether to pass input to the Lambda function"
  type        = bool
  default     = false
}

variable "enabled" {
  description = "Whether to enable the EventBridge Scheduler"
  type        = bool
  default     = true
}

variable "retry_policy" {
  description = "EventBridge Scheduler retry policy configuration (uses AWS defaults if null)"
  type = object({
    maximum_event_age_in_seconds = optional(number)
    maximum_retry_attempts       = optional(number)
  })
  default = null
}

variable "flexible_time_window" {
  description = "EventBridge Scheduler flexible time window configuration"
  type = object({
    mode = optional(string, "OFF")
    maximum_window_in_minutes = optional(number)
  })
  default = {
    mode = "OFF"
  }
}

variable "schedule_expression_timezone" {
  description = "EventBridge Scheduler timezone configuration"
  type        = string
  default     = "Asia/Tokyo"
}
