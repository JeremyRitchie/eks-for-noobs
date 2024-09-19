# EKS for Noobs: Your First Kubernetes Cluster on AWS

## Introduction

Welcome to EKS for Noobs! This repository contains Terraform code to deploy a simple, best-practice Kubernetes cluster on Amazon EKS (Elastic Kubernetes Service). Whether you're new to Kubernetes or looking to streamline your AWS deployments, this project provides a solid foundation for running containerized applications at scale.

## Prerequisites

Before you begin, ensure you have the following tools installed:

- [AWS CLI](https://aws.amazon.com/cli/)
- [Terraform](https://www.terraform.io/downloads.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)

You'll also need an AWS account and appropriate permissions to create EKS clusters and related resources.


## Quick Start

1. Clone this repository:
git clone https://github.com/jeremyritchie/eks-for-noobs.git cd eks-for-noobs

2. Review and modify the `terraform.tfvars`, `backend.tf`, `provider.tf`, `data.tf` files in each directory as needed.

3. Initialize Terraform:
terraform init

4. Deploy the EKS cluster:
cd eks
terraform apply --var-file ../terraform.tfvars

5. Deploy the EKS Config:
cd ../eks-config
terraform apply --var-file ../terraform.tfvars

6. Access your application:
After deployment, you can access the 2048 game at `https://2048.your-domain.com`
