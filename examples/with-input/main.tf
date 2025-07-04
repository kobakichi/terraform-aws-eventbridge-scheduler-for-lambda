# Example with input data
module "eventbridge_scheduler_with_input" {
  source = "../../"

  schedule_name       = "input-example"
  schedule_expression = "cron(0 9 * * ? *)" # Daily at 9 AM
  lambda_function_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:input-function"
  enable_input        = true

  lambda_input = {
    "environment" = "production"
    "task_type"   = "data-processing"
    "priority"    = "high"
  }
}

output "schedule_arn" {
  value = module.eventbridge_scheduler_with_input.schedule_arn
} 