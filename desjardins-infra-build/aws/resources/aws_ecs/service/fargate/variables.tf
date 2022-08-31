#
# Labels
#
variable "namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  default     = ""
  type        = string
}

variable "stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  default     = ""
  type        = string
}

variable "environment" {
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  default     = ""
  type        = string
}

variable "name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
  type        = string
}

variable "tags" {
  description = "Key-value mapping of tags for the IAM role"
  default     = {}
  type        = map(string)
}

variable "attributes" {
  description = "Additional attributes (e.g. `1`)"
  default     = []
  type        = list(string)
}

variable "label_order" {
  type        = list(string)
  default     = ["namespace", "environment"]
  description = "The naming order of the id output and Name tag"
}

#
# Specific vars
#
variable "capacity_provider_name" {
  description = "The short name of the capacity provider"
  default     = ""
  type        = string
}

variable "capacity_provider_weight" {
  description = "The relative pct of the total nb of launched tasks that should use the capacity provider"
  default     = 1
  type        = number
}

variable "capacity_provider_base" {
  description = "The number of tasks, at a minimum, to run on the specified capacity provider"
  default     = 0
  type        = number
}

variable "container_command" {
  description = "The command that is passed to the main container"
  type        = list(string)
}

variable "container_environment" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "The environment variables to pass to the container. This is a list of maps"
  default     = []
}

variable "container_image" {
  description = "The Docker image to use in the main container"
  type        = string
}

variable "container_name" {
  description = "The name of the main container"
  type        = string
}

variable "container_port_mappings" {
  description = "The list of port mappings for the main container"
  type        = list(any)
}

variable "container_secrets" {
  type = list(object({
    name      = string
    valueFrom = string
  }))
  description = "The SSM parameters to pass to the container. This is a list of maps"
  default     = []
}

variable "ecs_assign_public_ip" {
  description = "Assign a public IP address to the ENI"
  default     = false
  type        = bool
}

variable "ecs_cluster_id" {
  description = "ID of the target ECS cluster"
  type        = string
}

variable "ecs_cpu_units" {
  description = "The number of cpu units used by the task"
  type        = string
}

variable "ecs_exec_role_arn" {
  description = "The ARN of the role the Amazon ECS container agent that the Docker daemon can assume"
  type        = string
}

variable "ecs_launch_type" {
  description = "The launch type on which to run the service"
  type        = string
}

variable "ecs_memory_mib" {
  description = "The amount of memory (in MiB) used by the task"
  type        = string
}

variable "ecs_network_mode" {
  description = "The Docker networking mode to use. One of 'none', 'bridge', 'awsvpc', or 'host'"
  type        = string
}

variable "ecs_platform_version" {
  description = "The Fargate platform version on which to run the service. Must be null if not on Fargate"
  default     = "1.4.0"
  type        = string
}

variable "ecs_readonly_root_filesystem" {
  description = "Whether the root filesystem is ReadOnly, or not."
  default     = false
  type        = bool
}

variable "ecs_region" {
  description = "The region the ECS cluster is in"
  type        = string
}

variable "ecs_desired_replicas" {
  description = "The number of instances of the task definition to place and keep running"
  default     = "2"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "The ARN of the role the Amazon ECS task uses to call other AWS services"
  type        = string
}

variable "ecs_subnets" {
  description = "The subnets associated with the task or service"
  type        = list(string)
}

variable "efs_volumes" {
  description = "A list of EFS volume configurations"
  default     = []
  type = list(object({
    name           = string
    container_path = string
    volume_config = object({
      file_system_id = string
      root_directory = string
    })
  }))
}

variable "enable_ecs_managed_tags" {
  description = "Whether to enable Amazon ECS managed tags for the tasks within the service"
  default     = true
  type        = bool
}

variable "enable_ecs_logging" {
  description = "Whether to enable logging for tasks within the ECS service"
  default     = true
  type        = bool
}

variable "lb_health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks."
  default     = null
  type        = number
}

variable "lb_target_group_arn" {
  description = "The ARN of the Load Balancer target group to associate with the service"
  type        = string
}

variable "linux_parameters" {
  # https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_LinuxParameters.html
  description = "Linux-specific modifications that are applied to the container, such as Linux kernel capabilities."
  default     = null
  type = object({
    capabilities = object({
      add  = list(string)
      drop = list(string)
    })
    devices = list(object({
      containerPath = string
      hostPath      = string
      permissions   = list(string)
    }))
    initProcessEnabled = bool
    maxSwap            = number
    sharedMemorySize   = number
    swappiness         = number
    tmpfs = list(object({
      containerPath = string
      mountOptions  = list(string)
      size          = number
    }))
  })
}

variable "propagate_tags" {
  description = "Whether to propagate the tags from the task definition or the service to the tasks"
  default     = "SERVICE"
  type        = string
}

variable "security_group_ids" {
  description = "The Security Group ID's for the ECS service to join."
  default     = []
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
