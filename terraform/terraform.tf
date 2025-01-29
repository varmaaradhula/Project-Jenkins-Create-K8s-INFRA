terraform{

    required_version = ">=1.4.0"

    backend "s3" {
    bucket         = "barista-tf-state"
    key            = "terraform.tfstate" # Path to the state file
    region         = "eu-west-2"                      # S3 bucket region  
  }
  
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }

      kubernetes = {
        source = "hashicorp/kubernetes"
        version = "~> 2.23.0"
      }
    }
}
