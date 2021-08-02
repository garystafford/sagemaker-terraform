variable "region" {
  default = "us-east-1"
}

variable "notebook_instance_type" {
  description = "Amazon SageMaker notebook instance type"
  default = "ml.t2.medium"
  type = string

}

variable "code_repository" {
  description = "Git repository associated with your notebook instance"
  default = "https://github.com/aws/amazon-sagemaker-examples"
  type = string
}

variable "project_tag" {
  description = "Value of the 'Name' tag applied to all resources"
  default = "SageMaker PyTorch Workshop"
  type = string
}