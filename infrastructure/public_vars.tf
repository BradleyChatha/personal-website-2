// Defines any variables that can be put into git.

variable "aws_iam" {
  type = map(string)
  default = {
    "cli_local" = "terraform"
    "ec2"       = "terraform"
  }
  description = "Map of IAM profiles"
}

// There's literally no point in my personal website being cross-region.
// I want to sell myself in the UK/Europe, and eu-west-2 is perfectly fine for that region.
variable "aws_region" {
  type        = string
  default     = "eu-west-2"
  description = "The region to set up in"
}

variable "aws_az" {
  type = list(string)
  default = [
    "eu-west-2a",
    "eu-west-2b",
    "eu-west-2c",
  ]
}
