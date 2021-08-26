// Defines any variables that must be defined within the .gitignored file: private.tfvars
variable "my_ip" {
  type        = string
  description = "My IP Address"
}

variable "psql_host" {
  type = string
}

variable "psql_port" {
  type = number
}

variable "psql_username" {
  type = string
}

variable "psql_password" {
  type = string
}

variable "dub_updater_password" {
  type = string
}
