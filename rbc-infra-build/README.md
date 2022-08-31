# Terraform

This repository contains terraform HCL configuration for:

- `prod-infra-rbc`

## Tools Documentation

- [Terraform](https://www.terraform.io/docs/configuration/index.html)
- [Terragrunt](https://github.com/gruntwork-io/terragrunt)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/)
- [AWS Vault](https://github.com/99designs/aws-vault)
- [AWS ECR credentials helper](https://github.com/awslabs/amazon-ecr-credential-helper)
- [AWS Session Manager plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)

## Requirements

##### Install Terraform and Terragrunt 

```
$ brew install terraform
$ brew install terragrunt
```

##### Install AWS dependencies

- We're going to need a few tools to work with AWS.

```
$ brew install awscli
$ brew install --cask aws-vault
$ brew install docker-credential-helper-ecr
$ brew install --cask session-manager-plugin
```

##### Install Terraform dependencies

- We're also going to take control of the versions of `terraform` and `terragrunt` that we use to manage our infrastructure.

- Note the two files at the root of this repository: `.terraform-version` and `.terragrunt-version`

```
$ git clone https://github.com/tfutils/tfenv.git ~/.tfenv
$ git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
$ ln -s ~/.tfenv/bin/* /usr/local/bin
$ ln -s ~/.tgenv/bin/* /usr/local/bin
$ ./tfenv.sh
```

##### Install Terraform and Terragrunt

- Switch between installs of Terraform and Terragrunt by invoking our convenience script, like so:

```
$ ./tfenv.sh
```


#### Bring up the environment from scratch

- We've included a convenience script which brings up all cloud resources, in the correct order:

    - `./apply.sh`
    
- Updating individual resources can be done in their respective folders under `/deploys/rbc-prod/...`