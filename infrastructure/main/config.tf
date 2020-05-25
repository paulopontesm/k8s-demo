# config.tf - terraform and providers configuration

terraform {
  required_version = "~> 0.12"
  backend "s3" {
    encrypt = true
    # One day: https://github.com/hashicorp/terraform/issues/13022
    # bucket         = "terraform-state-${data.aws_caller_identity.current.account_id}"
    dynamodb_table = "terraform-lock"
    region         = "eu-west-1"
    key            = "k8s-demo/cluster.tfstate"
  }
}

provider "aws" {
  # Set your AWS configuration here. For more information see the terraform
  # provider information: https://www.terraform.io/docs/providers/aws/index.html
  # You might need to set AWS_SDK_LOAD_CONFIG=1 to use your aws credentials file
  region  = "eu-west-1"
  version = "~> 2.33"
}

provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  load_config_file       = false
  version                = "~> 1.5"
}
