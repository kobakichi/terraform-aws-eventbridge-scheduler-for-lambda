# Example with retry policy
module "eventbridge_scheduler_with_retry" {
  source = "../../"

  schedule_name        = "retry-example"
  schedule_expression  = "rate(10 minutes)"
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:retry-function"
  
  retry_policy = {
    maximum_event_age_in_seconds = 3600  # 1 hour
    maximum_retry_attempts       = 3     # Maximum 3 retries
  }
}

output "schedule_arn" {
  value = module.eventbridge_scheduler_with_retry.schedule_arn
} 