provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
  default_tags {
    tags = {
        Project     = "tv-lab"
        Environment = "prod"
        ManagedBy   = "Terraform"
        Owner       = "Tanvir"
    }
  }
}