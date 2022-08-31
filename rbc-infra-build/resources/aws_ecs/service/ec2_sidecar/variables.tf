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
  default     = ["environment", "name", "stage"]
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

variable "container_memory_mib" {
  description = "The amount (in MiB) of memory used by the task"
  default     = "512"
  type        = string
}

variable "container_cpu_units" {
  description = "The number of cpu units used by the task"
  default     = "256"
  type        = string
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

variable "container_working_directory" {
  description = "Set the container's working directory"
  type        = string
  default     = null
}

variable "docker_security_options" {
  description = "A list of strings to provide custom labels for SELinux and AppArmor multi-level security systems."
  type        = list(string)
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
  default     = "256"
  type        = string
}

variable "ecs_exec_role_arn" {
  description = "The ARN of the role the Amazon ECS container agent and the Docker daemon can assume"
  type        = string
}

variable "ecs_launch_type" {
  description = "The launch type on which to run the service"
  type        = string
}

variable "ecs_memory_mib" {
  description = "The amount (in MiB) of memory used by the task"
  default     = "512"
  type        = string
}

variable "ecs_network_mode" {
  description = "The Docker networking mode to use. One of 'none', 'bridge', 'awsvpc', or 'host'"
  type        = string
}

variable "ecs_platform_version" {
  description = "The Fargate platform version on which to run the service. Must be null if not on Fargate"
  default     = null
  type        = string
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
  description = "The subnets associated with the task or service. "
  type        = list(string)
}

variable "efs_volume_config" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#efs_volume_configuration
  description = "An EFS config block"
  type = list(object({
    name                    = string
    file_system_id          = string
    root_directory          = string
    transit_encryption      = string
    transit_encryption_port = string
    access_point_id         = string
    iam                     = string
    mount_point             = string
    readonly                = bool
  }))
  default = []
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

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks."
  default     = 120
  type        = number
}

variable "lb_target_group_arn" {
  description = "The ARN of the Load Balancer target group to associate with the service"
  type        = string
  default     = null
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

variable "network_configurations" {
  description = "List of network configuration blocks"
  type        = list(map(string))
  default     = []
}

variable "propagate_tags" {
  description = "Whether to propagate the tags from the task definition or the service to the tasks"
  default     = "SERVICE"
  type        = string
}

variable "s3_environment_files" {
  description = "One or more files containing the environment variables to pass to the container. This maps to the --env-file option to docker run. The file must be hosted in Amazon S3. This option is only available to tasks using the EC2 launch type. This is a list of maps"
  type = list(object({
    value = string
    type  = string
  }))
  default = []
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

#
# Sidecar variables
#
variable "sidecar_image" {
  description = "The Docker image to use in the sidecar container"
  type        = string
}

variable "sidecar_name" {
  description = "The name of the sidecar container"
  type        = string
}

variable "sidecar_command" {
  description = "The command that is passed to the main container"
  type        = list(string)
}

variable "sidecar_depends_on" {
  description = "The dependencies defined for container startup and shutdown."
  type = list(object({
    containerName = string
    condition     = string
  }))
}

variable "sidecar_environment" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "The environment variables to pass to the container. This is a list of maps"
  default     = []
}

variable "sidecar_secrets" {
  type = list(object({
    name      = string
    valueFrom = string
  }))
  description = "The SSM parameters to pass to the container. This is a list of maps"
  default     = []
}

variable "sidecar_working_directory" {
  description = "Set the container's working directory"
  type        = string
  default     = null
}

variable "sidecar_memory_mib" {
  description = "The amount (in MiB) of memory used by the task"
  default     = "512"
  type        = string
}

variable "sidecar_cpu_units" {
  description = "The number of cpu units used by the task"
  default     = "256"
  type        = string
}

variable "sidecar_port_mappings" {
  description = "The list of port mappings for the main container"
  type        = list(any)
}

variable "sidecar_linux_parameters" {
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

variable "sidecar_docker_security_options" {
  description = "A list of strings to provide custom labels for SELinux and AppArmor multi-level security systems."
  type        = list(string)
  default     = []
}

variable "sidecar_s3_environment_files" {
  description = "One or more files containing the environment variables to pass to the container. This maps to the --env-file option to docker run. The file must be hosted in Amazon S3. This option is only available to tasks using the EC2 launch type. This is a list of maps"
  type = list(object({
    value = string
    type  = string
  }))
  default = []
}
