// Defines any providers used.

provider "aws" {
  profile = var.aws_iam["cli_local"]
  region  = var.aws_region
}

provider "postgresql" {
  host      = var.psql_host
  port      = var.psql_port
  username  = var.psql_username
  password  = var.psql_password
  sslmode   = "require"
  superuser = false
}
