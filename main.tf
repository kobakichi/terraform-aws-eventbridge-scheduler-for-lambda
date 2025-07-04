# EventBridge Scheduler for Lambda function execution
# Supports dynamic configuration for retry policies, flexible time windows, and timezone settings

# EventBridge Scheduler Schedule
resource "aws_scheduler_schedule" "this" {
  name = var.schedule_name

  flexible_time_window {
    mode                      = var.flexible_time_window.mode
    maximum_window_in_minutes = var.flexible_time_window.maximum_window_in_minutes
  }

  schedule_expression = var.schedule_expression
  state               = var.enabled ? "ENABLED" : "DISABLED"

  target {
    arn      = var.lambda_function_arn
    role_arn = aws_iam_role.this.arn

    dynamic "retry_policy" {
      for_each = var.retry_policy != null ? [1] : []
      content {
        maximum_event_age_in_seconds = var.retry_policy.maximum_event_age_in_seconds
        maximum_retry_attempts       = var.retry_policy.maximum_retry_attempts
      }
    }

    input = var.enable_input ? jsonencode({
      "detail-type" = "Scheduled Event"
      "source"      = "aws.scheduler"
      "detail"      = var.lambda_input
    }) : null
  }

  # Set timezone
  schedule_expression_timezone = var.schedule_expression_timezone
}

# Lambda permission to allow EventBridge Scheduler to invoke the function
resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromEventBridgeScheduler"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "scheduler.amazonaws.com"
  source_arn    = aws_scheduler_schedule.this.arn
}

# EventBridge Scheduler assume role policy document
data "aws_iam_policy_document" "scheduler_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# EventBridge Scheduler IAM Role
resource "aws_iam_role" "this" {
  name               = "${var.schedule_name}-scheduler-role"
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume_role_policy.json
}

# Custom policy for Lambda function invocation
data "aws_iam_policy_document" "lambda_invoke_policy" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      var.lambda_function_arn
    ]
  }
}

# Create custom policy
resource "aws_iam_policy" "this" {
  name        = "${var.schedule_name}-lambda-invoke-policy"
  description = "Policy to allow EventBridge Scheduler to invoke Lambda function"
  policy      = data.aws_iam_policy_document.lambda_invoke_policy.json
}

# Attach Lambda execution policy to role
resource "aws_iam_role_policy_attachment" "lambda_invoke_policy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
