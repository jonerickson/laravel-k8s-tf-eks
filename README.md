# Laravel Deployment to EKS with Terraform and Helm

## Overview

This repository contains a Terraform module for deploying a Laravel application to Amazon EKS (Elastic Kubernetes Service) using Helm. The module automates the provisioning of the necessary AWS resources, including EKS clusters, VPCs, and security groups, and deploys the Laravel application using Helm charts.

## Prerequisites:

Before you begin, ensure you have the following tools installed:

1. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. [Helm](https://helm.sh/docs/intro/install/)
3. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
4. [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
5. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
6. [Docker](https://docs.docker.com/get-docker/)

### AWS Credentials

Ensure you have your AWS credentials configured on your local machine. You can do this by running the following command:

```bash
aws configure
```

### Creating The Infrastructure

1. Initialize the Terraform workspace:

```bash
terraform init
```

2. Plan the Terraform deployment:

```bash
terraform plan
```

3. Apply the Terraform deployment:

```bash
terraform apply
```

### Switch Kubectl Context

1. Set the new context to your recently deployed EKS cluster:

```bash
aws eks update-kubeconfig --region $(terraform output -raw region) --name $(terraform output -raw cluster_name)
```

### Installing AWS Load Balancer Controller (EKS Deployment)

1. Add the AWS Load Balancer Controller Helm repository:

```bash
helm repo add eks https://aws.github.io/eks-charts
``` 

2. Update the Helm repository:

```bash
helm repo update eks
```

3. Install the AWS Load Balancer Controller:

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$(terraform output -raw cluster_name) \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

### Installing Nginx Ingress Controller (Local Deployment)

1. Add the Nginx Helm repository:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

2. Install the Nginx Ingress Controller:

```bash
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set-string controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"="alb"
```