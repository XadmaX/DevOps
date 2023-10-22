# Installetion AWS EKS with eksctl

## Install AWS CLI : [link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

## Setup IAM role : [link](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html)

## Install eksctl : [link](https://eksctl.io/introduction/#installation)

## Create cluster

```shell
eksctl create cluster -f cluster.yaml
```

## Delete cluster

```shell
eksctl delete cluster -f cluster.yaml
```

## Examples of cluster configuration deployment files: [link](https://github.com/eksctl-io/eksctl/tree/main/examples)

## Get new cluster kubeconfig

```shell
aws eks update-kubeconfig --region eu-central-1 --name prog-kyiv-ua
```
