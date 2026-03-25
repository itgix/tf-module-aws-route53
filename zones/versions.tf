terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 2.49"
      # Route53 query logging requires CloudWatch log groups to be in us-east-1
      configuration_aliases = [aws.us_east_1]
    }
  }
}
