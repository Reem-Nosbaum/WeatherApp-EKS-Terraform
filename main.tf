provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
}

module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source      = "./modules/eks"
  subnet_ids  = module.vpc.private_subnet_ids
}

module "alb_controller" {
  source       = "./modules/alb_controller"
  cluster_name = module.eks.cluster_name
  oidc_issuer  = module.eks.oidc_issuer
  helm_version = "1.2.0"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  }
}
