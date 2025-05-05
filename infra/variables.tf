variable "kubernetes_version" {
  default     = 1.31
  description = "kubernetes version"
}

variable "aws_region" {
  default = "ap-south-1"
  description = "aws region"
}

variable "env" {
  description = "dev"
  type        = string
  default = "dev"
}

# variable "cluster_name" {
#   description = "Name of the Cluster"
#   type        = string
#   default     = "globant-project"
# }

variable "public_subnet_az1_id" {
  description = "Subnet ID for AZ1"
  type        = string
}

variable "public_subnet_az2_id" {
  description = "Subnet ID for AZ2"
  type        = string
}

variable "vpc_cidr" {
  description = "Default CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


