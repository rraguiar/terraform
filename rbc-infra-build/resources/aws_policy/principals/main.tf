data "aws_caller_identity" "this" {}

locals {
  defaults = {
    account_ids    = [],
    aws            = [],
    canonical_user = [],
    federated      = [],
    service        = [],
  }

  principals = merge(local.defaults, var.principals)

  account_ids = concat(
    local.principals.account_ids,
    var.account_ids,
  )

  aws = distinct(compact(concat(
    local.principals.aws,
    formatlist("arn:aws:iam::%s:root", local.account_ids),
    var.aws,
  )))

  canonical_user = distinct(compact(concat(
    local.principals.canonical_user,
    var.canonical_user,
  )))

  federated = distinct(compact(concat(
    local.principals.federated,
    var.federated,
  )))

  service = distinct(compact(concat(
    local.principals.service,
    var.service,
  )))

  data = merge({},
    length(local.aws) > 0 ? {
      AWS = local.aws
    } : {},
    length(local.federated) > 0 ? {
      Federated = local.federated
    } : {},
    length(local.canonical_user) > 0 ? {
      CanonicalUser = local.canonical_user
    } : {},
    length(local.service) > 0 ? {
      Service = local.service
    } : {},
  )

  total = (
    length(local.aws) +
    length(local.federated) +
    length(local.canonical_user) +
    length(local.service)
  )
}
