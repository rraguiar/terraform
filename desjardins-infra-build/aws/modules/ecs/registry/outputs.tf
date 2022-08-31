output "repos" {
  value = {
    admin       = module.admin
    api         = module.api
    assetstore  = module.assetstore
    maintenance = module.maintenance
    membersite  = module.membersite
  }
}
