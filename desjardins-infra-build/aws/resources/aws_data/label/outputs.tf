output "id" {
  value       = module.this.id
  description = "Disambiguated ID"
}

output "name" {
  value       = module.this.name
  description = "Normalized name"
}

output "namespace" {
  value       = module.this.namespace
  description = "Normalized namespace"
}

output "stage" {
  value       = module.this.stage
  description = "Normalized stage"
}

output "environment" {
  value       = module.this.environment
  description = "Normalized environment"
}

output "attributes" {
  value       = module.this.attributes
  description = "List of attributes"
}

output "delimiter" {
  value       = module.this.delimiter
  description = "Delimiter between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

output "tags" {
  value       = module.this.tags
  description = "Normalized Tag map"
}

output "tags_as_list_of_maps" {
  value       = module.this.tags_as_list_of_maps
  description = "Additional tags as a list of maps, which can be used in several AWS resources"
}

output "context" {
  value       = local.output_context
  description = "Context of this module to pass to other label modules"
}

output "label_order" {
  value       = module.this.label_order
  description = "The naming order of the id output and Name tag"
}

output "component" {
  value       = local.component
  description = "Normalized component"
}

output "path" {
  value       = local.output_context.path
  description = "The AWS SSM path"
}

output "region" {
  value       = local.output_context.region
  description = "The AWS region name"
}
