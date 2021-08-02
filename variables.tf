variable "region" {
  default = "us-east-1"
}

variable "notebook_instance_type" {
  default = "ml.t2.medium"
}

variable "code_repository" {
  default = "your_repo_path_here"
}

variable "project_tag" {
  default = "SageMaker PyTorch Workshop"
}