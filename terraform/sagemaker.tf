resource "aws_s3_bucket" "sagemaker_bucket" {
  bucket = "sagemaker-${var.region}-${data.aws_caller_identity.current.account_id}"
  acl = "private"
  tags = {
    Name = var.project_tag
  }
}

resource "aws_iam_role" "iam_role_sagemaker" {
  path = "/"
  name = "AmazonSageMakerFullAccess"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        Effect: "Allow",
        Principal: {
          "Service": "sagemaker.amazonaws.com"
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
  max_session_duration = 3600
  tags = {
    Name = var.project_tag
  }
}

resource "aws_iam_role_policy_attachment" "role-attach-1" {
  role = aws_iam_role.iam_role_sagemaker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "role-attach-2" {
  role = aws_iam_role.iam_role_sagemaker.name
  policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}

resource "aws_iam_role" "iam_role_step_functions" {
  path = "/"
  name = "StepFunctionsWorkflowExecutionRole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        Effect: "Allow",
        Principal: {
          "Service": "states.amazonaws.com"
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
  max_session_duration = 3600
  tags = {
    Name = var.project_tag
  }
}

resource "aws_iam_role_policy" "iam_policy_step_functions" {
  name = "StepFunctionsWorkflowExecutionPolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect : "Allow",
        Action : [
          "events:PutTargets",
          "events:DescribeRule",
          "events:PutRule"
        ],
        Resource : "arn:aws:events:*:*:rule/*"
      },
      {
        Effect : "Allow",
        Action : "iam:PassRole",
        Resource : "*",
        Condition : {
          "StringEquals" : {
            "iam:PassedToService" : "sagemaker.amazonaws.com"
          }
        }
      },
      {
        Effect : "Allow",
        Action : [
          "sagemaker:DescribeTrainingJob",
          "sagemaker:CreateModel",
          "sagemaker:DeleteEndpointConfig",
          "batch:SubmitJob",
          "dynamodb:DeleteItem",
          "sagemaker:StopProcessingJob",
          "sagemaker:CreateProcessingJob",
          "sagemaker:CreateTrainingJob",
          "batch:TerminateJob",
          "batch:DescribeJobs",
          "sagemaker:DescribeTransformJob",
          "sns:Publish",
          "ecs:RunTask",
          "sagemaker:StopHyperParameterTuningJob",
          "sagemaker:DeleteEndpoint",
          "dynamodb:GetItem",
          "glue:GetJobRun",
          "ecs:StopTask",
          "ecs:DescribeTasks",
          "sagemaker:CreateTransformJob",
          "sagemaker:ListTags",
          "sagemaker:CreateEndpoint",
          "dynamodb:PutItem",
          "lambda:InvokeFunction",
          "sqs:SendMessage",
          "dynamodb:UpdateItem",
          "glue:BatchStopJobRun",
          "sagemaker:StopTrainingJob",
          "sagemaker:DescribeHyperParameterTuningJob",
          "sagemaker:UpdateEndpoint",
          "sagemaker:CreateEndpointConfig",
          "glue:StartJobRun",
          "sagemaker:StopTransformJob",
          "sagemaker:CreateHyperParameterTuningJob",
          "glue:GetJobRuns"
        ],
        Resource : "*"
      }
    ]
  })
  role = aws_iam_role.iam_role_step_functions.name
}

resource "aws_iam_role_policy" "iam_policy_sagemaker_pass_step_functions" {
  name = "SageMakerPassStepFunctionsWorkflowExecutionRole"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect : "Allow",
        Action : [
          "iam:PassRole"
        ],
        Resource : aws_iam_role.iam_role_step_functions.arn
      }
    ]
  })
  role = aws_iam_role.iam_role_sagemaker.name
}

resource "aws_sagemaker_code_repository" "example_repo" {
  code_repository_name = "workshop-notebook-instance-code-repo"

  git_config {
    repository_url = var.code_repository
  }
}

resource "aws_sagemaker_notebook_instance" "notebook_instance" {
  name = "workshop-notebook-instance"
  role_arn = aws_iam_role.iam_role_sagemaker.arn
  instance_type = var.notebook_instance_type
  default_code_repository = aws_sagemaker_code_repository.example_repo.code_repository_name
  tags = {
    Name = var.project_tag
  }
}