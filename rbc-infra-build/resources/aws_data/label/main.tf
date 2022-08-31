#
# AWS Naming module
#
# This module is designed to provide consistent naming conventions and tagging
# to all resources deployed with terraform. We're making use of the cloudposse
# module as a base and are extending it with a few additional attributes.
#
# https://github.com/cloudposse/terraform-null-label
#
data "aws_region" "this" {}

locals {
  defaults = merge({
    component = var.component
    path      = var.path,
    region    = data.aws_region.this.name
    sentinel  = "~"
  }, module.defaults.context)

  #
  # Region
  #
  region_codes = {
    "ap-northeast-1" = "apne1"
    "ap-northeast-2" = "apne2"
    "ap-south-1"     = "aps1"
    "ap-southeast-1" = "apse1"
    "ap-southeast-2" = "apse2"
    "ca-central-1"   = "cac1"
    "cn-north-1"     = "cnn1"
    "eu-west-1"      = "euw1"
    "eu-west-2"      = "euw2"
    "eu-west-3"      = "euw3"
    "sa-east-1"      = "sae1"
    "us-east-1"      = "use1"
    "us-east-2"      = "use2"
    "us-west-1"      = "usw1"
    "us-west-2"      = "usw1"
  }

  region      = coalesce(var.region, var.context.region, local.defaults.region)
  region_code = lookup(local.region_codes, local.region, "")

  component = split("/",
    coalesce(
      local.defaults.component,
      module.defaults.name,
      lookup(var.tags, "Name", ""),
      module.defaults.id,
    )
  )[0]

  environment = replace(
    coalesce(
      replace(local.defaults.environment, local.defaults.sentinel, ""),
      format("%s%s", local.region_code, local.defaults.stage),
      local.defaults.sentinel
    ),
    local.defaults.sentinel,
    ""
  )

  path = replace(
    coalesce(
      local.defaults.path,
      module.path.id,
      local.defaults.sentinel
    ),
    local.defaults.sentinel,
    ""
  )

  #
  # Pass to upstream
  #
  output_context = merge(module.this.context, {
    component = local.component,
    path      = local.path,
    region    = local.region,
  })
}

module "defaults" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"

  namespace           = var.namespace
  environment         = var.environment
  stage               = var.stage
  name                = var.name
  enabled             = true
  delimiter           = var.delimiter
  attributes          = var.attributes
  tags                = var.tags
  additional_tag_map  = var.additional_tag_map
  context             = var.context
  label_order         = var.label_order
  regex_replace_chars = var.regex_replace_chars
}

module "path" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"

  delimiter           = "/"
  environment         = local.environment
  context             = local.defaults
  regex_replace_chars = var.regex_replace_chars
}

module "this" {
  source              = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"
  context             = local.defaults
  delimiter           = var.delimiter
  environment         = local.environment
  regex_replace_chars = var.regex_replace_chars
  tags = {
    Component = local.component
    Path      = local.path
  }
}
