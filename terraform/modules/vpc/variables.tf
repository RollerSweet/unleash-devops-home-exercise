variable "name" {
  description = "Name prefix for the VPC."
  type        = string
}

variable "cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "List of availability zones to spread subnets across."
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks."
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to provision NAT gateways."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Create a single shared NAT gateway."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to the VPC resources."
  type        = map(string)
  default     = {}
}
