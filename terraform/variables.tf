variable codestar_connection_arn {
  type = string
}

variable repository_id {
  type = string
}

variable aws_account_id {
  type = string
}

variable aws_region {
  type = string
}

variable container_name {
  type = string
}

variable "ecr_repository_name" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets_cidr" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "private_subnets_cidr" {
  type = list(string)
}

variable "health_check_path" {
  type = string
}

variable "ecs_desired_count" {
  type = number
}
