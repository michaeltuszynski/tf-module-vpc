variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = null
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = null
}

variable "subnet_type" {
  description = "Type of subnets to create: public, private, or both"
  type        = string
  default     = "both"
  validation {
    condition     = contains(["public", "private", "both"], var.subnet_type)
    error_message = "subnet_type must be one of 'public', 'private', or 'both'"
  }
}
