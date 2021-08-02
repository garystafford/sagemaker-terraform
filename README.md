# Notes

## Terraform Commands with New Sandbox Accounts

```shell
rm -rf .terraform.*
terraform init
terraform plan
terraform apply
```

## Issues with Notebooks

* `pytorch-workflow-1-data-prep.ipynb`
    * No issues.

* `pytorch-workflow-2-train.ipynb`
    * 2 places - `'framework_version':'1.5.1',` - Throws error - no 1.5.1? Change to 1.6
      * Latest `sagemaker` version is 2.25.0 Run `python3 -m pip install -U sagemaker==2.25.0`
      * Latest pytorch supported by `sagemaker` is 1.8.1
          * Latest pytorch (`torch`) version is 1.9.0

* `pytorch-workflow-3-deploy.ipynb`
    * `framework_version='1.5.1'` > `framework_version='1.5', py_version='py3'` (Production Variants with Model Monitor)
    * Endpoints, like `pytorch-housing` - won't that be a problem with multiple users overwriting?
    * Comment out 2 lines of attributes - see below
    * Pinned to older v1 version of awscli==1.18.140 (now aws-cli/2.2.15) - `!pip install --upgrade awscli`
    * `framework_version='1.5.1'` > `framework_version='1.5', py_version='py3'` (Production Variants with Model Monitor)
    * Couldn't fix several errors: `ClientError: An error occurred (ValidationException) when calling the CreateEndpointConfig operation: Could not find model "arn:aws:sagemaker:us-east-1:307920926045:model/pytorch-tuning-01-11-42-49-003-20772488".` >> `pytorch-tuning-01-11-42-49-003-20772488-2021-08-01-12-35-10-861`

* `pytorch-workflow-4-pipeline.ipynb`
    * Having multiple users creating same role and policy will be issue > now done with Terraform
        * Had to add additional role? `iam:PassRole` to avoid error
    * Comment out 2 lines of attributes - see below

```python
# local_predictor.content_type = "application/json"
# local_predictor.accept = "application/json"
```

```python
# predictor.content_type = "application/json"
# predictor.accept = "application/json"
```

```python
# tuning_predictor.content_type = "application/json"
# tuning_predictor.accept = "application/json"
```

```python
# mme_predictor.serializer = json_serializer
# mme_predictor.content_type = 'application/json'
```

```python
# workflow_predictor.content_type = "application/json"
# workflow_predictor.accept = "application/json"

```

```shell
# UnknownServiceError: Unknown service: 'sagemaker-featurestore-runtime'.
# !pip install --upgrade awscli==1.18.140
!pip install --upgrade awscli #boto boto3 botocore
```

## SageMaker Instance Resources

* Deployment
    * Notebook Instance: (1x) ml.t2.medium
* `pytorch-workflow-1-data-prep.ipynb`
    * Processing Job: (1x) ml.m5.xlarge
* `pytorch-workflow-2-train.ipynb`
    * Processing Job: (1x) ml.m5.2xlarge
    * Processing Job: (1x) ml.m5.2xlarge
    * Training: (2x) ml.c5.xlarge (on-demand) aka Hyperparameter tuning jobs
    * Training: (4x) ml.c5.xlarge (spot) aka Hyperparameter tuning jobs
    * Inference: (1x) ml.t2.medium
* `pytorch-workflow-3-deploy.ipynb`
    * Processing Job: (1x) ml.m5.large
    * Inference: (1x) ml.t2.medium (mme-pytorch)
    * Inference: (1x) ml.t2.medium (pytorch-housing-auto)
    * Inference: (1x) ml.t2.medium (pytorch-housing)
* `pytorch-workflow-4-pipeline.ipynb`
    * Processing Job: (1x) ml.m5.2xlarge
    * Training: (2x) ml.c5.xlarge (on-demand) aka Hyperparameter tuning jobs
    * Inference: (1x) ml.c5.xlarge