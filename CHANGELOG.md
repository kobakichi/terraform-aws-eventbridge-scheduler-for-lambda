# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-19

### Added
- Initial release of EventBridge Scheduler module
- Support for Lambda function invocation scheduling
- Dynamic retry policy configuration
- Flexible time window settings
- Timezone configuration support
- Input data support for Lambda functions
- Custom IAM policies using data sources
- Comprehensive variable validation
- Multiple usage examples

### Changed
- Repository name updated to `terraform-aws-eventbridge-scheduler-for-lambda`
- Updated all documentation and examples to reflect new repository name

### Features
- EventBridge Scheduler resource creation
- IAM role and policy management
- Retry policy with configurable attempts and event age
- Flexible time window with configurable mode and maximum window
- Schedule expression timezone support
- Optional input data for Lambda functions
- Module state management (enabled/disabled)

### Documentation
- Comprehensive README with usage examples
- Variable and output documentation
- MIT License
- Multiple example configurations 