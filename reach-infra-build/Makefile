init:
	terraform init

get-stage:
	terraform workspace select stage
	
plan-stage:
	terraform plan --var-file="env/stage.tfvars"

apply-stage:
	terraform apply -auto-approve --var-file="env/stage.tfvars"

get-uat:
	terraform workspace select uat
	
plan-uat:
	terraform plan --var-file="env/uat.tfvars"

apply-uat:
	terraform apply -auto-approve --var-file="env/uat.tfvars"

get-prod:
	terraform workspace select prod
	
plan-prod:
	terraform plan --var-file="env/prod.tfvars"

apply-prod:
	terraform apply --var-file="env/prod.tfvars"