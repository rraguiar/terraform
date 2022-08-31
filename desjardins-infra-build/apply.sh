#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

export BASE="./aws/deploys/desjardins-staging"

declare -a paths=(
  "${BASE}/iam/roles"
  "${BASE}/iam/groups"
  "${BASE}/iam/users"
  "${BASE}/vpc/eips"
  "${BASE}/vpc/network"
  "${BASE}/kms"
  "${BASE}/s3"
  "${BASE}/ssm/parameters"
  "${BASE}/efs/netsuite"
  "${BASE}/efs/sftp"
  "${BASE}/efs/web_import_files"
  "${BASE}/efs/web_storage"
  "${BASE}/ecs/registry"
  "${BASE}/ec2/security_groups/admin/lb"
  "${BASE}/ec2/security_groups/admin/svc"
  "${BASE}/ec2/security_groups/api/lb"
  "${BASE}/ec2/security_groups/api/svc"
  "${BASE}/ec2/security_groups/assets/lb"
  "${BASE}/ec2/security_groups/assets/svc"
  "${BASE}/ec2/security_groups/codebuild"
  "${BASE}/ec2/security_groups/listener/svc"
  "${BASE}/ec2/security_groups/maintenance/lb"
  "${BASE}/ec2/security_groups/maintenance/svc"
  "${BASE}/ec2/security_groups/members/lb"
  "${BASE}/ec2/security_groups/members/svc"
  "${BASE}/ec2/security_groups/scheduler/svc"
  "${BASE}/codestar/codecommit/quayio_sync"
  "${BASE}/codestar/codebuild/admin_sync"
  "${BASE}/codestar/codebuild/api_sync"
  "${BASE}/codestar/codebuild/assetstore_sync"
  "${BASE}/codestar/codebuild/listener_sync"
  "${BASE}/codestar/codebuild/maintenance_sync"
  "${BASE}/codestar/codebuild/membersite_sync"
  "${BASE}/codestar/codebuild/scheduler_sync"
  "${BASE}/rds/mysql"
  "${BASE}/ec2/load_balancers/admin"
  "${BASE}/ec2/load_balancers/api"
  "${BASE}/ec2/load_balancers/assets"
  "${BASE}/ec2/load_balancers/maintenance"
  "${BASE}/ec2/load_balancers/members"
  "${BASE}/ecs/cluster"
  "${BASE}/ecs/services/admin"
  "${BASE}/ecs/services/api"
  "${BASE}/ecs/services/assets"
  "${BASE}/ecs/services/listener"
  "${BASE}/ecs/services/maintenance"
  "${BASE}/ecs/services/members"
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
  aws-vault exec desjardins-staging -- terragrunt init
  aws-vault exec desjardins-staging -- terragrunt plan -out /tmp/tfplan -input=false
  aws-vault exec desjardins-staging -- terragrunt apply -input=false /tmp/tfplan
  popd
done
