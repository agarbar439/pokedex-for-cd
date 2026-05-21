// Creation ECR 
variable "region" {
    type = string
    default = "eu-north-1"
}

variable "ecr_repository_name" {
    type = string
    default = "pokedex"
}

variable "vpc"{
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_name"{
    type = string
    default = "VPC Pokedex"
}

variable "public_subnet_cidrs"{
    type = list(string)
    description = "Public Subnet CIDR values"
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs"{
    type = list(string)
    description = "Private Subnet CIDR values"
    default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs"{
    type = list(string)
    description = "Availability Zones"
    default     = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "pokedex"
}

variable "public_port" {
  description = "Port for the final user (HTTP)"
  type        = number
  default     = 80
}

variable "container_port" {
  description = "Port of the application"
  type        = number
  default     = 5000
}

variable "health_check_path" {
  description = "Health check route for the Target Group"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Health check interval (seconds)"
  type        = number
  default     = 30
}

variable "app_count" {
  description = "Number of application instances"
  type        = number
  default     = 2
}

