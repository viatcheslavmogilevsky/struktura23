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
tofu -chdir=root-module init --backend-config=backend.tfvars
tofu -chdir=root-module validate
tofu -chdir=root-module plan
tofu -chdir=root-module apply
```

### How to use k8s cluster

```bash
# export AWS_PROFILE=example-aws-profile
aws eks --region us-west-2  update-kubeconfig --name test --kubeconfig=kubeconfig.yaml
KUBECONFIG=$(pwd)/kubeconfig.yaml kubectl apply -f deployment.yaml
KUBECONFIG=$(pwd)/kubeconfig.yaml k9s -A
```


### How to destroy k8s cluster

```bash
# export AWS_PROFILE=example-aws-profile
tofu -chdir=root-module destroy
```

### Miscellaneous

```bash
# export AWS_PROFILE=example-aws-profile
tofu -chdir=root-module init --backend-config=backend.tfvars
tofu -chdir=root-module plan --out binary.tfplan
tofu -chdir=root-module show -json binary.tfplan > plan.tfplan.json
tofu -chdir=root-module show -no-color binary.tfplan > plan.tfplan.txt 2>&1
```