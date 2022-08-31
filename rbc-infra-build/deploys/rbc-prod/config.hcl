inputs = {
  aws = {
    account_id       = "738001968068"
    region           = "ca-central-1"
    role_suffix      = "terraform"
    vpc_default_id   = "vpc-db7eaabe"
  }
  label = {
    organization = "rbc"
    namespace    = "infra"
    stage        = "prod"
    environment  = "rbc"
    tags         = {
      owner            = "devsecops@engagepeople.com"
      application_name = "rbc"
      managed_by       = "devsecops@engagepeople.com"
      deployment_tool  = "terraform"
      project          = "rbc"
      customer         = "infra"
    }
  }
  inputs = {}
}
