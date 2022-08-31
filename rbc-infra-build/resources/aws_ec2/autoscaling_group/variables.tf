#
# Labels
#
variable "namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  default     = ""
  type        = string
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
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
  type        = map(any)
}

variable "label_order" {
  type        = list(string)
  default     = ["stage", "namespace", "environment", "name"]
  description = "The naming order of the id output and Name tag"
}

#
# Specific vars
#
variable "ami_id" {
  description = "The AMI from which to launch the instance"
  default     = null
  type        = string
}

variable "ami_instance_type" {
  description = "The AMI instance type"
  type        = string
}

variable "ami_name" {
  description = "AMI name prefix to lookup"
  type        = string
}

variable "ami_owners" {
  description = "List of AMI owner account IDs"
  type        = list(string)
}

variable "asg_default_cooldown" {
  description = "The time, in seconds, between two distinct scaling events"
  default     = 300
  type        = number
}

variable "asg_health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = 300
  type        = number
}

variable "asg_health_check_type" {
  description = "Controls how health checking is done, EC2 or ELB"
  default     = "EC2"
  type        = string
}

variable "asg_max_size" {
  description = "The maximum size of the autoscaling group"
  default     = 0
  type        = number
}

variable "asg_max_instance_lifetime" {
  description = "The maximum amount of time, in seconds, that an instance can be in service"
  default     = 0
  type        = number
}

variable "asg_min_size" {
  description = "The minimum size of the autoscaling group"
  default     = 0
  type        = number
}

variable "asg_protect_from_scale_in" {
  description = "The ASG will not select instances with this setting for termination during scale in events"
  default     = false
  type        = bool
}

variable "block_device_mappings" {
  description = "EBS Volumes to attach to the instance besides the volumes specified by the AMI"
  default     = []
  type        = list(any)
}

variable "cpu_credits" {
  description = "Customize the CPU credit specification of the instance. Either 'standard' or 'unlimited'"
  default     = "standard"
  type        = string
}

variable "ebs_optimized" {
  description = "Whether the EC2 instances are EBS-optimized or not"
  default     = true
  type        = bool
}

variable "enable_detailed_monitoring" {
  description = "Launched EC2 instance will have detailed monitoring enabled"
  default     = true
  type        = bool
}

variable "enabled_metrics" {
  description = "A list of metrics to collect."
  type        = set(string)
  default = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
  ]
}

variable "lt_description" {
  description = "The description of the launch template"
  default     = null
  type        = string
}

variable "iam_instance_role_name" {
  description = "The name of the IAM role to attach to the ASG instance profile"
  type        = string
}

variable "iam_policy_arns" {
  description = "List of IAM policy arns to attach"
  default     = []
  type        = list(string)
}

variable "iam_policy_map" {
  description = "Map of IAM policies to attach"
  default     = {}
  type        = map(string)
}

variable "key_name" {
  description = "The key name to use for the instance"
  default     = null
  type        = string
}

variable "network_interfaces" {
  description = "Attaches one or more Network Interfaces to the instance"
  default     = [{}]
  type        = list(map(string))
}

variable "security_group_ids" {
  description = "List of additional security groups to be a member of"
  default     = []
  type        = list(string)
}

variable "security_group_rules" {
  description = "List of security group rules to create"
  default     = {}
  type        = map(map(string))
}

variable "security_group_targets" {
  description = "List of security group trust rules to create"
  default     = {}
  type        = map(map(string))
}

variable "user_data" {
  description = "The Base64-encoded user data to provide when launching the instance"
  default     = null
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs for a virtual private cloud (VPC)"
  type        = set(string)
}