#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

export BASE="./deploys/rbc-uat2"

declare -a paths=(
  "${BASE}/iam/roles"
  "${BASE}/iam/groups"
  "${BASE}/vpc/eips"
  "${BASE}/vpc/network"
  "${BASE}/kms"
  "${BASE}/s3"
  "${BASE}/secrets"
  "${BASE}/efs/file_system/shared_files"
  "${BASE}/efs/access_point/shared_files"
  "${BASE}/ec2/security_groups/admin/lb"
  "${BASE}/ec2/security_groups/admin/svc"
  "${BASE}/ec2/security_groups/admin_v1/lb"
  "${BASE}/ec2/security_groups/admin_v1/svc"
  "${BASE}/ec2/security_groups/api/lb"
  "${BASE}/ec2/security_groups/api/svc"
  "${BASE}/ec2/security_groups/api_extended/svc"
  "${BASE}/ec2/security_groups/extended_listener/svc"
  "${BASE}/ec2/security_groups/extended_nginx/lb"
  "${BASE}/ec2/security_groups/extended_nginx/svc"
  "${BASE}/ec2/security_groups/extended_scheduler/svc"
  "${BASE}/ec2/security_groups/listener/lb"
  "${BASE}/ec2/security_groups/listener/svc"
  "${BASE}/ec2/security_groups/membersite/lb"
  "${BASE}/ec2/security_groups/membersite/svc"
  "${BASE}/ec2/security_groups/scheduler/svc"
  "${BASE}/ec2/load_balancers/admin"
  "${BASE}/ec2/load_balancers/admin_v1"
  "${BASE}/ec2/load_balancers/api"
  "${BASE}/ec2/load_balancers/extended_nginx"
  "${BASE}/ec2/load_balancers/listener"
  "${BASE}/ec2/load_balancers/membersite"
  "${BASE}/ec2/autoscaling_groups/deploy"
  "${BASE}/ec2/autoscaling_groups/ecs_node"
  "${BASE}/rds/podium"
  "${BASE}/rds/podium_extended"
  "${BASE}/elasticache/podium"
  "${BASE}/elasticache/podium_extended"
  "${BASE}/ecs/cluster"
  "${BASE}/ecs/services/admin"
  "${BASE}/ecs/services/admin_v1"
  "${BASE}/ecs/services/api"
  "${BASE}/ecs/services/api_extended"
  "${BASE}/ecs/services/extended_listener"
  "${BASE}/ecs/services/extended_nginx"
  "${BASE}/ecs/services/extended_scheduler"
  "${BASE}/ecs/services/listener"
  "${BASE}/ecs/services/membersite"
  "${BASE}/ecs/services/scheduler"
)

for p in "${paths[@]}"
do
  echo ""
  echo "***************************************************************************************************************"
  echo "* APPLY :: ${p}"
  echo "***************************************************************************************************************"
  echo ""

  pushd $p
  aws-vault exec rbc-production -- terragrunt init
  aws-vault exec rbc-production -- terragrunt plan -out /tmp/tfplan -input=false
  aws-vault exec rbc-production -- terragrunt apply -input=false /tmp/tfplan
  popd
done
