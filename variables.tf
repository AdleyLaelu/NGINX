variable "aws_region" {
  description = "AWS region for the ECS deployment"
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  default     = "nginx-cluster"
}

variable "task_definition_name" {
  description = "Name of the ECS task definition"
  default     = "nginx-task-definition"
}

variable "service_name" {
  description = "Name of the ECS service"
  default     = "nginx-service"
}

variable "subnets" {
  description = "List of public subnet IDs for the ECS service"
  type        = list(string)
  default     = ["subnet-07045a5e85a6fd5bf", "subnet-01b370924dd7ffc1c"]
}

variable "security_groups" {
  description = "List of security group IDs for the ECS service"
  type        = list(string)
  default     = ["sg-0417994d9b572727a"]
}

variable "vpc_id" {
  description = "VPC ID for the ECS deployment"
  default     = "vpc-016011f0b7704c990"
}
