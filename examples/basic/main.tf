# Basic example of EventBridge Scheduler module
module "eventbridge_scheduler" {
  source = "../../"

  schedule_name       = "basic-example"
  schedule_expression = "rate(5 minutes)"
  lambda_function_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:example-function"
}

# Output the schedule ARN
output "schedule_arn" {
  value = module.eventbridge_scheduler.schedule_arn
} 