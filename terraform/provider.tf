provider "aws" {
  region  = "ap-northeast-1"
  profile = "training"

  default_tags {
    tags = {
      Project   = "ecs-terraform-training"
      ManagedBy = "Terraform"
    }
  }
}