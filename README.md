# AWS EventBridge Scheduler for Lambda - Terraform Module

[![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D1.0-blue.svg)](https://www.terraform.io/downloads.html)
[![AWS Provider](https://img.shields.io/badge/aws-%7E%3E5.0-orange.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A Terraform module for creating AWS EventBridge Scheduler resources to invoke Lambda functions on a schedule. This module supports flexible time windows, retry policies, timezone configuration, and optional input data for Lambda functions.

## Features

- 🕒 **Flexible Scheduling**: Support for both rate and cron expressions
- 🌍 **Timezone Support**: Configurable timezone for schedule expressions
- 🔄 **Retry Policies**: Configurable retry attempts and event age
- 📝 **Input Data**: Optional input data for Lambda functions
- 🛡️ **IAM Security**: Custom IAM policies using data sources
- ⚙️ **Dynamic Configuration**: Flexible time window settings
- 🎛️ **State Management**: Enable/disable scheduler state

## Usage

### Basic Example

```hcl
module "eventbridge_scheduler" {
  source = "github.com/kobakichi/terraform-aws-eventbridge-scheduler-for-lambda"

  schedule_name        = "my-lambda-scheduler"
  schedule_expression  = "rate(5 minutes)"
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:my-function"
}
```

### With Input Data

```hcl
module "eventbridge_scheduler_with_input" {
  source = "github.com/kobakichi/terraform-aws-eventbridge-scheduler-for-lambda"

  schedule_name        = "data-processing-scheduler"
  schedule_expression  = "cron(0 9 * * ? *)"  # Daily at 9 AM
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:data-processor"
  enable_input         = true
  
  lambda_input = {
    "environment" = "production"
    "task_type"   = "data-processing"
    "priority"    = "high"
  }
}
```

### With Retry Policy

```hcl
module "eventbridge_scheduler_with_retry" {
  source = "github.com/kobakichi/terraform-aws-eventbridge-scheduler-for-lambda"

  schedule_name        = "retry-enabled-scheduler"
  schedule_expression  = "rate(10 minutes)"
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:retry-function"
  
  retry_policy = {
    maximum_event_age_in_seconds = 3600  # 1 hour
    maximum_retry_attempts       = 3     # Maximum 3 retries
  }
}
```

### With Custom Timezone and Flexible Time Window

```hcl
module "eventbridge_scheduler_custom" {
  source = "github.com/kobakichi/terraform-aws-eventbridge-scheduler-for-lambda"

  schedule_name        = "custom-timezone-scheduler"
  schedule_expression  = "cron(0 12 * * ? *)"  # Daily at 12 PM
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:custom-function"
  
  schedule_expression_timezone = "Asia/Tokyo"
  
  flexible_time_window = {
    mode                      = "FLEXIBLE"
    maximum_window_in_minutes = 15
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_scheduler_schedule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_invoke_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.scheduler_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_invoke_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| schedule_name | Name of the EventBridge Scheduler schedule | `string` | n/a | yes |
| schedule_expression | Schedule expression (rate or cron) | `string` | n/a | yes |
| lambda_function_arn | ARN of the Lambda function to invoke | `string` | n/a | yes |
| enabled | Whether the schedule is enabled | `bool` | `true` | no |
| enable_input | Whether to enable input data for Lambda function | `bool` | `false` | no |
| lambda_input | Input data to pass to Lambda function (when enable_input is true) | `any` | `{}` | no |
| retry_policy | Retry policy configuration | `object` | `null` | no |
| retry_policy.maximum_event_age_in_seconds | Maximum age of event in seconds | `number` | n/a | no |
| retry_policy.maximum_retry_attempts | Maximum number of retry attempts | `number` | n/a | no |
| flexible_time_window | Flexible time window configuration | `object` | `{"mode": "OFF", "maximum_window_in_minutes": 0}` | no |
| flexible_time_window.mode | Mode of flexible time window (OFF, FLEXIBLE) | `string` | n/a | no |
| flexible_time_window.maximum_window_in_minutes | Maximum window in minutes | `number` | n/a | no |
| schedule_expression_timezone | Timezone for schedule expression | `string` | `"UTC"` | no |

## Outputs

| Name | Description |
|------|-------------|
| schedule_arn | ARN of the EventBridge Scheduler schedule |
| schedule_name | Name of the EventBridge Scheduler schedule |
| role_arn | ARN of the IAM role used by the scheduler |
| role_name | Name of the IAM role used by the scheduler |
| policy_arn | ARN of the IAM policy for Lambda invocation |
| policy_name | Name of the IAM policy for Lambda invocation |

## Examples

See the [examples](./examples) directory for more usage examples:

- [Basic Example](./examples/basic) - Simple scheduler setup
- [With Input](./examples/with-input) - Scheduler with input data
- [With Retry](./examples/with-retry) - Scheduler with retry policy

## Schedule Expression Examples

### Rate Expressions
- `rate(5 minutes)` - Every 5 minutes
- `rate(1 hour)` - Every hour
- `rate(7 days)` - Every 7 days

### Cron Expressions
- `cron(0 12 * * ? *)` - Daily at 12:00 PM UTC
- `cron(0 9 ? * MON-FRI *)` - Weekdays at 9:00 AM UTC
- `cron(0 0 1 * ? *)` - Monthly on the 1st at midnight UTC

## Retry Policy

The retry policy allows you to configure how EventBridge Scheduler handles failed Lambda invocations:

```hcl
retry_policy = {
  maximum_event_age_in_seconds = 3600  # Maximum age of event before dropping
  maximum_retry_attempts       = 3     # Maximum number of retry attempts
}
```

## Flexible Time Window

Flexible time windows allow EventBridge Scheduler to execute within a time range rather than at an exact time:

```hcl
flexible_time_window = {
  mode                      = "FLEXIBLE"  # OFF or FLEXIBLE
  maximum_window_in_minutes = 15          # Maximum execution window
}
```

## IAM Permissions

This module creates the following IAM resources:

- **Role**: Assumed by EventBridge Scheduler
- **Policy**: Allows `lambda:InvokeFunction` on the specified Lambda function
- **Attachment**: Links the policy to the role

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Security

Please read [SECURITY.md](SECURITY.md) for details on our security policy.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.