# Makefile for EventBridge Scheduler Terraform Module

.PHONY: help init plan apply destroy fmt validate test clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Initialize Terraform
	cd test && terraform init

plan: ## Plan Terraform changes
	cd test && terraform plan

apply: ## Apply Terraform changes
	cd test && terraform apply

destroy: ## Destroy Terraform resources
	cd test && terraform destroy

fmt: ## Format Terraform files
	terraform fmt -recursive

validate: ## Validate Terraform configuration
	terraform validate

test: ## Run tests
	cd test && terraform init && terraform plan

clean: ## Clean up temporary files
	find . -name "*.tfstate*" -delete
	find . -name ".terraform" -type d -exec rm -rf {} +
	find . -name ".terraform.lock.hcl" -delete 