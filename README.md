# AWS EventBridge Scheduler Terraform Module

This Terraform module provides a comprehensive solution for creating AWS EventBridge Scheduler resources to execute Lambda functions on a schedule. It supports dynamic configuration for retry policies, flexible time windows, timezone settings, and input data.

## Terraform Registry

```hcl
module "eventbridge_scheduler" {
  source = "kobakichi/eventbridge-scheduler/aws"
  version = "1.0.0"

  schedule_name        = "my-lambda-schedule"
  schedule_expression  = "rate(5 minutes)"
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:my-function"
}
```

## Features

- **Flexible Scheduling**: Support for both rate and cron expressions
- **Timezone Configuration**: Configurable timezone settings (defaults to Asia/Tokyo)
- **Retry Policies**: Configurable retry policies with AWS defaults
- **Flexible Time Windows**: Support for flexible execution windows
- **Input Data**: Optional input data to pass to Lambda functions
- **IAM Management**: Automatic creation of IAM roles and policies
- **State Management**: Enable/disable scheduler state
- **AWS Default Group**: Uses AWS default scheduler group

## Usage

### Basic Example

```hcl
module "lambda_scheduler" {
  source = "kobakichi/eventbridge-scheduler/aws"
  version = "1.0.0"

  schedule_name        = "my-lambda-schedule"
  schedule_expression  = "rate(5 minutes)"
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:my-function"
  enable_input         = true

  lambda_input = {
    "key1" = "value1"
    "key2" = "value2"
  }
}
```

### Daily Schedule Example

```hcl
module "daily_lambda_scheduler" {
  source = "kobakichi/eventbridge-scheduler/aws"
  version = "1.0.0"

  schedule_name        = "daily-lambda-schedule"
  schedule_expression  = "cron(0 9 * * ? *)"  # Daily at 9 AM (Tokyo time)
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:daily-function"
}
```

### Without Input Data

```hcl
module "simple_lambda_scheduler" {
  source = "kobakichi/eventbridge-scheduler/aws"
  version = "1.0.0"

  schedule_name        = "simple-lambda-schedule"
  schedule_expression  = "rate(1 hour)"
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:simple-function"
  enable_input         = false
}
```

### With Input Data

```hcl
module "input_lambda_scheduler" {
  source = "kobakichi/eventbridge-scheduler/aws"
  version = "1.0.0"

  schedule_name        = "input-lambda-schedule"
  schedule_expression  = "rate(30 minutes)"
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:input-function"
  enable_input         = true

  lambda_input = {
    "environment" = "production"
    "task_type"   = "data-processing"
    "priority"    = "high"
  }
}
```

### Disabled Schedule Example

```hcl
module "disabled_lambda_scheduler" {
  source = "kobakichi/eventbridge-scheduler/aws"
  version = "1.0.0"

  schedule_name        = "disabled-lambda-schedule"
  schedule_expression  = "rate(1 hour)"
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:disabled-function"
  enabled              = false
}
```

### Custom Retry Policy Example

```hcl
module "retry_lambda_scheduler" {
  source = "kobakichi/eventbridge-scheduler/aws"
  version = "1.0.0"

  schedule_name        = "retry-lambda-schedule"
  schedule_expression  = "rate(10 minutes)"
  lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:123456789012:function:retry-function"

  retry_policy = {
    maximum_event_age_in_seconds = 3600  # 1 hour
    maximum_retry_attempts       = 3     # Maximum 3 retries
  }
}
```

### Flexible Time Window and Timezone Customization

```hcl
module "flexible_scheduler" {
  source = "kobakichi/eventbridge-scheduler/aws"
  version = "1.0.0"

  schedule_name        = "flexible-schedule"
  schedule_expression  = "cron(0 12 * * ? *)"  # Daily at 12 PM
  lambda_function_arn  = "arn:aws:lambda:..."

  # Enable flexible time window (allow up to 15 minutes delay)
  flexible_time_window = {
    mode = "FLEXIBLE"
    maximum_window_in_minutes = 15
  }

  # Use UTC timezone
  schedule_expression_timezone = "UTC"
}
```

## Variables

| Variable Name | Description | Type | Required | Default |
|---------------|-------------|------|----------|---------|
| `schedule_name` | Name of the EventBridge Scheduler schedule | string | Yes | - |
| `schedule_expression` | Schedule expression | string | Yes | - |
| `lambda_function_arn` | ARN of the target Lambda function | string | Yes | - |
| `lambda_input` | Input data to pass to the Lambda function | map(any) | No | {} |
| `enable_input` | Whether to pass input to the Lambda function | bool | No | false |
| `enabled` | Whether to enable the EventBridge Scheduler | bool | No | true |
| `retry_policy` | Retry policy configuration | object | No | null |
| `flexible_time_window` | Flexible time window configuration | object | No | { mode = "OFF" } |
| `schedule_expression_timezone` | Timezone for schedule expression | string | No | "Asia/Tokyo" |

## Schedule Expression Examples

- `rate(5 minutes)` - Every 5 minutes
- `rate(1 hour)` - Every hour
- `rate(1 day)` - Every day
- `cron(0 12 * * ? *)` - Daily at 12 PM
- `cron(0 9 * * MON *)` - Every Monday at 9 AM

## Flexible Time Window Configuration

The flexible time window controls the execution flexibility of EventBridge Scheduler.

### Flexible Time Window Parameters

| Parameter | Description | Default | Options |
|-----------|-------------|---------|---------|
| `mode` | Flexible time window mode | "OFF" | "OFF", "FLEXIBLE" |
| `maximum_window_in_minutes` | Maximum window time in minutes | null | 1-1440 |

### Examples

```hcl
# Disable flexible time window (default)
flexible_time_window = {
  mode = "OFF"
}

# Enable flexible time window (allow up to 30 minutes delay)
flexible_time_window = {
  mode = "FLEXIBLE"
  maximum_window_in_minutes = 30
}
```

## Timezone Configuration

The `schedule_expression_timezone` specifies the timezone for the schedule expression.

### Common Timezones

- `"Asia/Tokyo"` - Japan Standard Time (default)
- `"UTC"` - Coordinated Universal Time
- `"America/New_York"` - Eastern Standard Time
- `"Europe/London"` - Greenwich Mean Time

### Examples

```hcl
# Japan time (default)
schedule_expression_timezone = "Asia/Tokyo"

# UTC time
schedule_expression_timezone = "UTC"

# Eastern Standard Time
schedule_expression_timezone = "America/New_York"
```

## Retry Policy Configuration

The retry policy controls the retry behavior when EventBridge Scheduler fails to execute the Lambda function.

### Default Behavior

- `retry_policy = null` (default): Uses AWS default values
  - `maximum_event_age_in_seconds = 86400` (24 hours)
  - `maximum_retry_attempts = 185`
- When `retry_policy` is specified: Uses the specified values

### Retry Policy Parameters

| Parameter | Description | AWS Default | Range |
|-----------|-------------|-------------|-------|
| `maximum_event_age_in_seconds` | Maximum event age in seconds | 86400 (24 hours) | 60-86400 |
| `maximum_retry_attempts` | Maximum retry attempts | 185 | 0-185 |

### Examples

#### Using AWS Default Values (Recommended)
```hcl
module "default_retry_scheduler" {
  source = "kobakichi/eventbridge-scheduler/aws"
  version = "1.0.0"

  schedule_name        = "default-retry-schedule"
  schedule_expression  = "rate(10 minutes)"
  lambda_function_arn  = "arn:aws:lambda:..."
  # retry_policy = null  # Default value (uses AWS defaults)
}
```

#### Custom Values
```hcl
module "custom_retry_scheduler" {
  source = "kobakichi/eventbridge-scheduler/aws"
  version = "1.0.0"

  schedule_name        = "custom-retry-schedule"
  schedule_expression  = "rate(10 minutes)"
  lambda_function_arn  = "arn:aws:lambda:..."

  retry_policy = {
    maximum_event_age_in_seconds = 3600  # 1 hour
    maximum_retry_attempts       = 3     # Maximum 3 retries
  }
}
```

## Outputs

| Output Name | Description |
|-------------|-------------|
| `schedule_arn` | ARN of the EventBridge Scheduler |
| `schedule_name` | Name of the EventBridge Scheduler |
| `scheduler_role_arn` | ARN of the EventBridge Scheduler IAM role |
| `scheduler_role_name` | Name of the EventBridge Scheduler IAM role |
| `lambda_invoke_policy_arn` | ARN of the Lambda execution policy |
| `lambda_invoke_policy_name` | Name of the Lambda execution policy |
| `retry_policy_config` | Retry policy configuration |
| `flexible_time_window_config` | Flexible time window configuration |
| `schedule_expression_timezone` | Timezone for schedule expression |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Notes

- This module uses the Asia/Tokyo timezone by default
- Lambda function ARN must be in the correct format
- IAM roles and policies are automatically created and attached
- Custom policies grant execution permissions only to the specified Lambda function
- The module uses AWS default scheduler group