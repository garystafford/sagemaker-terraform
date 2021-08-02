variable "region" {
  default = "us-east-1"
}

variable "notebook_instance_type" {
  default = "ml.t2.medium"
}

variable "code_repository" {
  default = "https://github.com/garystafford/sagemaker-pytorch-demo.git"
}

variable "project_tag" {
  default = "SageMaker Workshop"
}