// Defines any Terraform backends.
terraform {
    backend "s3" {
        bucket  = "bradley-chatha"
        key     = "terraform/state.tfstate"
        region  = "eu-west-2"
        profile = "terraform"
    }
}