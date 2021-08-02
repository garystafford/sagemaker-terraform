# Amazon SageMaker/PyTorch Workshop Infrastructure

Terraform code to provision resources in a new AWS Account for an Amazon SageMaker/PyTorch Workshop.

## Terraform Commands with New AWS Account

```shell
# if used in previous account with local state file
rm -rf .terraform.*

terraform init

terraform plan

terraform apply -auto-approve
```