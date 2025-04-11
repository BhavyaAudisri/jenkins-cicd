
variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "expense"
    Environment = "dev"
    Terraform   = "true"
  }
}


variable "instance_type" {

  default = "t3.micro"
}


variable "security_group_id" {
  default = "sg-02f18e4bed9d09120"

}
variable "zone_name" {
  type        = string
  default     = "somisettibhavya.life"
  description = "description"
}