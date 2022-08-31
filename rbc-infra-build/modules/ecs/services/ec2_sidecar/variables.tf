variable "aws" {
  description = "AWS provider variables"
  type = object({
    account_id = string
    region     = string
    role_arn   = string
  })
}

variable "label" {
  description = "Label variables"
  type = object({
    organization = string
    namespace    = string
    stage        = string
    environment  = string
    name         = string
    tags         = map(string)
  })
}

#
# Specific vars
#
variable "container_command" {
  description = "The command that is passed to the container"
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
  description = "The Docker image of the service hosted in the container"
  type        = string
}

variable "container_name" {
  description = "The name of the main container"
  type        = string
}

variable "container_port_mappings" {
  description = "The list of port mappings for the container"
  type        = list(any)
}

variable "container_cpu_units" {
  description = "The amount of CPU to allocate to the ECS task"
  type        = string
}

variable "container_memory_mib" {
  description = "The amount of RAM to allocate to the ECS task, in MiB"
  type        = string
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
  description = "Whether to assign a public IP to the task instance"
  type        = bool
}

variable "ecs_autoscaling_enabled" {
  description = "Whether Application Autoscaling should be enabled"
  type        = bool
  default     = false
}

variable "ecs_autoscaling_target_cpu_pct" {
  description = "The target average CPU utilization for the service on which to trigger scaling events"
  type        = string
  default     = 50
}

variable "ecs_autoscaling_target_mem_pct" {
  description = "The target average RAM utilization for the service on which to trigger scaling events"
  type        = string
  default     = 50
}

variable "ecs_autoscaling_scale_in_cooldown" {
  description = "The time, in seconds, since the last scale-in event to wait until triggering another"
  type        = string
  default     = 60
}

variable "ecs_autoscaling_scale_out_cooldown" {
  description = "The time, in seconds, since the last scale-out event to wait until triggering another"
  type        = string
  default     = 60
}

variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "ecs_capacity_provider_name" {
  description = "The short name of the capacity provider"
  default     = ""
  type        = string
}

variable "ecs_capacity_provider_weight" {
  description = "The relative pct of the total nb of launched tasks that should use the capacity provider"
  default     = 1
  type        = number
}

variable "ecs_capacity_provider_base" {
  description = "The number of tasks, at a minimum, to run on the specified capacity provider"
  default     = 0
  type        = number
}

variable "ecs_cpu_units" {
  description = "The amount of CPU to allocate to the ECS task"
  type        = string
}

variable "ecs_memory_mib" {
  description = "The amount of RAM to allocate to the ECS task, in MiB"
  type        = string
}

variable "ecs_desired_replicas" {
  description = "The nb. of replicas to launch the ECS task with"
  type        = string
}

variable "ecs_exec_role_arn" {
  description = "The ARN of the role the Amazon ECS container agent and the Docker daemon can assume"
  type        = string
}

variable "ecs_launch_type" {
  description = "The launch type of the ECS data plane. Either 'FARGATE' or 'EC2'"
  type        = string
}

variable "ecs_max_replicas" {
  description = "The MAX nb. of replicas to which the service can scale"
  type        = string
}

variable "ecs_min_replicas" {
  description = "The MIN nb. of replicas to which the service can scale"
  type        = string
}

variable "ecs_network_mode" {
  description = "The Docker networking mode to use. One of 'none', 'bridge', 'awsvpc', or 'host'"
  type        = string
}

variable "ecs_platform_version" {
  description = "The Fargate platform version on which to run the service. Must be 'null' if not on Fargate"
  default     = null
  type        = string
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

variable "lb_internal" {
  description = "Whether the Load Balancer is internal (private) or not (public)"
  default     = true
  type        = bool
}

variable "lb_target_group_arn" {
  description = "The ARN of the associated Load Balancer's target group"
  default     = null
  type        = string
}

variable "lb_health_check_grace_period_seconds" {
  description = "The time, in seconds, the LB health check will wait before tallying failures."
  default     = 120
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

variable "network_configurations" {
  description = "List of network configuration blocks"
  type        = list(map(string))
  default     = []
}

variable "route53_alias_zone_id" {
  description = "The AWS-managed Hosted Zone ID where the resource to Alias lives"
  type        = string
  default     = null
}

variable "route53_alias_fqdn" {
  description = "The FQDN of the resource we want to Alias."
  type        = string
  default     = null
}

variable "route53_create_alias" {
  description = "Whether to create a Route53 Alias record, or not."
  type        = bool
  default     = false
}

variable "route53_fqdn" {
  description = "The FQDN of the Alias to create."
  type        = string
  default     = null
}

variable "route53_zone_id" {
  description = "The Hosted Zone ID where the Alias will be created"
  type        = string
  default     = null
}

variable "s3_bucket_arns" {
  description = "ARMs pf the S3 buckets we want the service to access"
  type        = list(string)
  default     = []
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
  description = "The Security Group ID's for the Load Balancer to join. ALB only."
  default     = []
  type        = list(string)
}

variable "subnet_ids" {
  description = "Map of VPC subnet_ids"
  type = object({
    private = list(string)
    public  = list(string)
  })
}

variable "secrets_key_arn" {
  description = "ARN of the secrets KMS key"
  type        = string
}

variable "storage_key_arn" {
  description = "ARN of the storage KMS key"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
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

variable "sidecar_depends_on" {
  description = "The dependencies defined for container startup and shutdown."
  type = list(object({
    containerName = string
    condition     = string
  }))
}