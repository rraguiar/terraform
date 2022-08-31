#
# Common vars
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
  default     = ["namespace", "environment", "name"]
  description = "The naming order of the id output and Name tag"
}

#
# Specific vars
#

variable "artifacts_type" {
  description = "Build output artifact's type. Valid values: CODEPIPELINE, NO_ARTIFACTS, S3."
  type        = string
  default     = "NO_ARTIFACTS"
}

variable "build_timeout" {
  description = "Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. The default is 60 minutes."
  type        = number
  default     = 60
}

variable "cache" {
  description = "Build cache configuration"
  type = list(object({
    location = string # Location where the AWS CodeBuild project stores cached resources. For type S3, the value must be a valid S3 bucket name/prefix.
    modes    = string # Specifies settings that AWS CodeBuild uses to store and reuse build dependencies. Valid values: LOCAL_SOURCE_CACHE, LOCAL_DOCKER_LAYER_CACHE, LOCAL_CUSTOM_CACHE.
    type     = string # Type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO_CACHE, LOCAL, S3. Defaults to NO_CACHE.
  }))
  default = []
}

variable "compute_type" {
  description = "Information about the compute resources the build project will use. Valid values: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE. BUILD_GENERAL1_SMALL is only valid if type is set to LINUX_CONTAINER. When type is set to LINUX_GPU_CONTAINER, compute_type must be BUILD_GENERAL1_LARGE."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "env_vars" {
  description = "Environment variables to supply to the build"
  type = list(object({
    name  = string # Environment variable's name or key.
    value = string # Environment variable's value.
    type  = string # Type of environment variable. Valid values: PARAMETER_STORE, PLAINTEXT, SECRETS_MANAGER.
  }))
  default = []
}

variable "image" {
  description = "Docker image to use for this build project. Valid values include Docker images provided by CodeBuild (e.g aws/codebuild/standard:2.0), Docker Hub images (e.g. hashicorp/terraform:latest), and full Docker repository URIs such as those for ECR (e.g. 137112412989.dkr.ecr.us-west-2.amazonaws.com/amazonlinux:latest)."
  type        = string
  default     = "aws/codebuild/standard:5.0"
}

variable "image_pull_credentials_type" {
  description = "Type of credentials AWS CodeBuild uses to pull images in your build. Valid values: CODEBUILD, SERVICE_ROLE."
  type        = string
  default     = "CODEBUILD"
}

variable "privileged_mode" {
  description = "Whether to enable running the Docker daemon inside a Docker container. Defaults to false."
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "Security group IDs to assign to running builds."
  type        = list(string)
  default     = []
}

variable "service_role_arn" {
  description = "The ARN of the IAM service role"
  type        = string
}

variable "source_git_clone_depth" {
  description = "Truncate git history to this many commits. Use 0 for a Full checkout which you need to run commands like git branch --show-current."
  type        = number
  default     = 1
}

variable "source_git_submodules_config" {
  description = "Whether to fetch Git submodules for the AWS CodeBuild build project."
  type        = bool
  default     = true
}

variable "source_location" {
  description = "URI of the source code from git or s3."
  type        = string
}

variable "source_type" {
  description = "Type of repository that contains the source code to be built. Valid values: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET or S3."
  type        = string
  default     = "CODECOMMIT"
}

variable "source_version" {
  description = "Version of the build input to be built for this project. If not specified, the latest version is used."
  type        = string
  default     = "refs/heads/main"
}

variable "subnet_ids" {
  description = "Subnet IDs within which to run builds."
  type        = list(string)
  default     = []
}

variable "type" {
  description = "Type of build environment to use for related builds. Valid values: LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_CONTAINER (deprecated), WINDOWS_SERVER_2019_CONTAINER, ARM_CONTAINER."
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "vpc_id" {
  description = "ID of the VPC within which to run builds."
  type        = string
}
