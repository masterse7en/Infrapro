variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "infrapro"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_cidr" {
  description = "CIDR allowed to SSH into the servers"
  type        = string
  default     = "0.0.0.0/0"
}

variable "managed_node_count" {
  description = "Number of managed nodes"
  type        = number
  default     = 2
}
