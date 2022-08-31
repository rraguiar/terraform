#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

export BASE="./aws/deploys/desjardins-staging"

declare -a paths=(
  "${BASE}/ecs/services/scheduler"
  "${BASE}/ecs/services/members"
  "${BASE}/ecs/services/maintenance"
  "${BASE}/ecs/services/listener"
  "${BASE}/ecs/services/assets"
  "${BASE}/ecs/services/api"
  "${BASE}/ecs/services/admin"
  "${BASE}/ecs/cluster"
  "${BASE}/ec2/load_balancers/members"
  "${BASE}/ec2/load_balancers/maintenance"
  "${BASE}/ec2/load_balancers/assets"
  "${BASE}/ec2/load_balancers/api"
  "${BASE}/ec2/load_balancers/admin"
  "${BASE}/rds/mysql"
  "${BASE}/codestar/codebuild/scheduler_sync"
  "${BASE}/codestar/codebuild/membersite_sync"
  "${BASE}/codestar/codebuild/maintenance_sync"
  "${BASE}/codestar/codebuild/listener_sync"
  "${BASE}/codestar/codebuild/assetstore_sync"
  "${BASE}/codestar/codebuild/api_sync"
  "${BASE}/codestar/codebuild/admin_sync"
  "${BASE}/codestar/codecommit/quayio_sync"
  "${BASE}/ec2/security_groups/scheduler/svc"
  "${BASE}/ec2/security_groups/members/svc"
  "${BASE}/ec2/security_groups/members/lb"
  "${BASE}/ec2/security_groups/maintenance/svc"
  "${BASE}/ec2/security_groups/maintenance/lb"
  "${BASE}/ec2/security_groups/listener/svc"
  "${BASE}/ec2/security_groups/codebuild"
  "${BASE}/ec2/security_groups/assets/svc"
  "${BASE}/ec2/security_groups/assets/lb"
  "${BASE}/ec2/security_groups/api/svc"
  "${BASE}/ec2/security_groups/api/lb"
  "${BASE}/ec2/security_groups/admin/svc"
  "${BASE}/ec2/security_groups/admin/lb"
#  "${BASE}/ecs/registry"
  "${BASE}/efs/web_storage"
  "${BASE}/efs/web_import_files"
  "${BASE}/efs/sftp"
  "${BASE}/efs/netsuite"
#  "${BASE}/ssm/parameters"
#  "${BASE}/s3"
#  "${BASE}/kms"
  "${BASE}/vpc/network"
#  "${BASE}/vpc/eips"
#  "${BASE}/iam/users"
#  "${BASE}/iam/groups"
#  "${BASE}/iam/roles"
)

for p in "${paths[@]}"
do
  echo ""
  echo "***************************************************************************************************************"
  echo "* DESTROY :: ${p}"
  echo "***************************************************************************************************************"
  echo ""

  pushd $p
  aws-vault exec desjardins-staging -- terragrunt destroy -auto-approve
  popd
done
