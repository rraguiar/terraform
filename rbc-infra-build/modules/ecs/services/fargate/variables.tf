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
    namespace   = string
    stage       = string
    environment = string
    name        = string
    tags        = map(string)
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

variable "container_port_mappings" {
  description = "The list of port mappings for the container"
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
  description = "Whether to assign a public IP to the task instance"
  default     = false
  type        = bool
}

variable "ecs_autoscaling_target_cpu_pct" {
  description = "The target average CPU utilization for the service on which to trigger scaling events"
  type        = string
}

variable "ecs_autoscaling_target_mem_pct" {
  description = "The target average RAM utilization for the service on which to trigger scaling events"
  type        = string
}

variable "ecs_autoscaling_scale_in_cooldown" {
  description = "The time, in seconds, since the last scale-in event to wait until triggering another"
  type        = string
}

variable "ecs_autoscaling_scale_out_cooldown" {
  description = "The time, in seconds, since the last scale-out event to wait until triggering another"
  type        = string
}

variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "ecs_cpu_units" {
  description = "The amount of CPU to allocate to the ECS task"
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

variable "ecs_memory_mib" {
  description = "The amount of RAM to allocate to the ECS task, in MiB"
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

variable "ecs_desired_replicas" {
  description = "The nb. of replicas to launch the ECS task with"
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

variable "ecs_readonly_root_filesystem" {
  description = "Whether the root filesystem is ReadOnly, or not."
  default     = false
  type        = bool
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

variable "lb_health_check_grace_period_seconds" {
  description = "Seconds to ignore failing LB health checks on newly instantiated tasks to prevent premature shutdown"
  default     = null
  type        = number
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

variable "storage_key_arn" {
  description = "ARN of the storage KMS key"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
