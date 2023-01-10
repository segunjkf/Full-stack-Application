module "vpc" {
  source = "./modules/vpc"

  env_code     = var.env_code
  private_cidr = var.private_cidr
  public_cidr  = var.public_cidr
  vpc_cidr     = var.vpc_cidr
}

module "eks" {
  source = "./modules/eks"

  eks-name        = var.eks-name
  node_group_name = var.node_group_name
  private_subnets = module.vpc.subnet_id_private
  public_subnets  = module.vpc.subnet_id_public
}