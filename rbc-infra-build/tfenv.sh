#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

tfenv install
tgenv install $(cat .terragrunt-version)

tfenv use
tgenv use $(cat .terragrunt-version)
