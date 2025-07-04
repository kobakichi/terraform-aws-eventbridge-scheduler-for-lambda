# EventBridge Scheduler Module Outputs

output "schedule_arn" {
  description = "ARN of the EventBridge Scheduler"
  value       = aws_scheduler_schedule.this.arn
}

output "schedule_name" {
  description = "Name of the EventBridge Scheduler"
  value       = aws_scheduler_schedule.this.name
}

output "scheduler_role_arn" {
  description = "ARN of the EventBridge Scheduler IAM role"
  value       = aws_iam_role.this.arn
}

output "scheduler_role_name" {
  description = "Name of the EventBridge Scheduler IAM role"
  value       = aws_iam_role.this.name
}

output "lambda_invoke_policy_arn" {
  description = "ARN of the Lambda execution policy"
  value       = aws_iam_policy.this.arn
}

output "lambda_invoke_policy_name" {
  description = "Name of the Lambda execution policy"
  value       = aws_iam_policy.this.name
}

output "retry_policy_config" {
  description = "Retry policy configuration"
  value       = var.retry_policy
}

output "flexible_time_window_config" {
  description = "Flexible time window configuration"
  value       = var.flexible_time_window
}

output "schedule_expression_timezone" {
  description = "Timezone for schedule expression"
  value       = var.schedule_expression_timezone
}
