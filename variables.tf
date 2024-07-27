variable aws_access_key {
  type        = string
  default     = ""
  description = "AWS access key"
  sensitive = true
}

variable aws_secret_key {
  type        = string
  default     = ""
  description = "AWS secret key"
  sensitive = true
}

variable aws_region {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}
