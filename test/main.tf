# Test configuration for EventBridge Scheduler module
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# Test Lambda function (mock ARN)
locals {
  test_lambda_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:test-function"
}

# Test the module
module "test_scheduler" {
  source = "../"

  schedule_name        = "test-scheduler"
  schedule_expression  = "rate(1 minute)"
  lambda_function_arn  = local.test_lambda_arn
  enabled             = false  # Disabled for testing
}

output "test_schedule_arn" {
  value = module.test_scheduler.schedule_arn
} 