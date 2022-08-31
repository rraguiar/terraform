# TO BE UPDATED

# accessplus-infra-build

Terraform code to stand up new Access Plus environment.

Assets to be deployed:
+ 1 node ECS cluster
+ 1 node RDS cluster
+ 1 node Redis cluster
+ 1 S3 private bucket

ECS Services:
+ Generic API
+ Amazon API
+ Laravel Horizon

## Installation

Requirements:
+ Terraform v0.12.25
+ provider.aws v2.66.0
+ provider.random v2.2.1

Update env/"environment".tfvars file with environment specific attributes.

## Usage
Terraform:
```bash
make get-<environment>
make plan-<environment>
make apply-<environment>
```
Certificates:
Get the key from secrets store, generate a csr for RapidSSL

```bash
openssl req -new -config configs/amazon_api.cnf -keyout amazon_api.key -out amazon_api.csr
```
## Naming convention
1. Keypairs: <environment>-<customer>-<application_name>-<service_role>-keypair
    Example: staging-rbc-podium-deploy-keypair

## Steps

1. Create the following keypairs before execute the "terraform apply": 
    1. List of Keypairs:
        Deploy
        Node

    

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

