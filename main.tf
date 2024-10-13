module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr_1 = "10.0.1.0/24"
  public_subnet_cidr_2 = "10.0.2.0/24"
  private_subnet_cidr_1 = "10.0.3.0/24"
  private_subnet_cidr_2 = "10.0.4.0/24"
  region              = "us-east-1"
  project_tag         = "my-eks-project"
}

module "iam" {
  source = "./modules/iam"
  project_tag = "my-eks-project"
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.26"
  desired_capacity = 2
  min_size         = 1
  max_size         = 3
  instance_type    = "t3.medium"
  subnet_ids       = module.vpc.private_subnet_ids
  vpc_id           = module.vpc.vpc_id
  project_tag      = "my-eks-project"

  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn
}
