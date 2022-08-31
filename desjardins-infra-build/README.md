# Terraform

This repository contains terraform HCL configuration for:

- `desjardins-staging`

## Tools Documentation

- [Terraform](https://www.terraform.io/docs/configuration/index.html)
- [Terragrunt](https://github.com/gruntwork-io/terragrunt)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/)
- [AWS Vault](https://github.com/99designs/aws-vault)
- [AWS ECR credentials helper](https://github.com/awslabs/amazon-ecr-credential-helper)
- [AWS Session Manager plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)

## Requirements

##### Install AWS dependencies

- We're going to need a few tools to work with AWS.

```
$ brew install awscli
$ brew cask install aws-vault
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

##### Configure your AWS account

`TODO(froch, 20210514)` Add the documentation to Confluence, and link back here.

Prior to using this product, you will want to make sure that your AWS Credentials are configured correctly.
To do so you will want to go through the [Documentation]().

##### Configure your shell

Optionally, here are some helpers you might find useful:

`$ vi ~/.bashrc`

```
alias tg='aws-vault exec desjardins-staging -- terragrunt'          # alias to save some repetetive typing
export TERRAGRUNT_DOWNLOAD=$HOME/.terragrunt-cache                  # global terragrunt cache
```

`$ source ~/.bashrc`

## Structure

- `./aws/deploys/...`
    - The Terraform deployments. This is where we invoke `tg plan` and `tg apply`.
    - Usually, this only contains a single `terragrunt.hcl` file.
    - When appropriate, it's also possible to override individual elements with `.tf` files, but we should really try to avoid doing so.

- `./aws/modules/...`
    - Custom AWS Terraform modules, to be re-used per project.
    - A module can contain several custom resources that belong together.
    - The more resources contained, the larger the blast radius; hence, we should seek to strike the balance between element composition and overall risk on `apply`.

- `./aws/resources/...`
    - Custom AWS cloud resource definitions.
    - These are the atomic building blocks used by the modules, above.
    - Composition can also happen here, to subsequently be implicit at the module level.

## Before you begin

Ensure you have MFA enabled for your AWS account and configured in your `~/.aws/config`,
as described in the [Documentation]().

IAM roles cannot be created or assumed with Terraform if MFA is not enabled, even with `AdministratorAccess`.
The error returned is: `InvalidClientTokenId when creating IAM Roles`.

## Usage

`TODO(froch, 20210514)` Expand on this.

There are two convenience scripts at the root of the repository, which can be used to automate the setup / teardown of 
environments. 

They respectively invoke `tg apply` and `tg destroy` on the cloud resources we need, in the correct 
sequence for dependencies to resolve.

```
$ ./apply.sh
$ ./destroy.sh
```

## Enabling remote command execution on ECS services

AWS has finally enabled [remote access to ECS containers](https://aws.amazon.com/blogs/containers/new-using-amazon-ecs-exec-access-your-containers-fargate-ec2/) on Fargate.

To enable the feature for future tasks spawned from a service:

- Launch an ECS service using Terraform.

```
$ cd aws/deploys/desjardins-staging/ecs/services/api
$ tge apply
```

- Explicitly enable the feature at the Service level.

```
$ AWS_PROFILE=desjardins-staging aws ecs update-service \
    --cluster desjardins-staging \
    --service api \
    --enable-execute-command
```


- Confirm that the feature has been enabled.

```
$ AWS_PROFILE=desjardins-staging aws ecs update-service \
    --cluster desjardins-staging \
    --service api \
    | grep enableExecuteCommand

"enableExecuteCommand": true
```

- Kill a current Task instance of the targeted Service via the AWS Web Console. This will force a new Task instance to spawn.

- Confirm that the required properties are enabled in the new Task's description:

```
$ AWS_PROFILE=desjardins-staging aws ecs describe-tasks \
    --cluster desjardins-staging \
    --tasks cc408c34057a4d0891b820983b5b086b \
    | grep enableExecuteCommand

"enableExecuteCommand": true
```
```
$ AWS_PROFILE=desjardins-staging aws ecs describe-tasks \
    --cluster desjardins-staging \
    --tasks cc408c34057a4d0891b820983b5b086b \
    | grep ExecuteCommandAgent -B 2 -A 2

{
    "lastStartedAt": "2021-06-08T13:01:52.108000-04:00",
    "name": "ExecuteCommandAgent",
    "lastStatus": "RUNNING"
}
```

- When the `lastStatus` property above is `RUNNING`, obtain a shell session in the remote Docker container.

```
$ AWS_PROFILE=desjardins-staging aws ecs execute-command  \
    --cluster desjardins-staging \
    --task cc408c34057a4d0891b820983b5b086b \
    --container api \
    --command "/bin/bash" \
    --interactive
```
