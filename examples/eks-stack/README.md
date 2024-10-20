# EKS stack example

Simple example of EKS cluster

### Folder structure


* `modules` - contains local opentofu modules which used in `root-module`
* `root-module` - main opentofu directory


### Prerequisites

* opentofu
* access to AWS account with s3 state bucket and dynamodb table


### How to run
To initialize and run opentofu, please run: 

```bash
# export AWS_PROFILE=example-aws-profile
cd ./root-module
tofu init  --backend-config=backend.tfvars
tofu plan
tofu apply
```

