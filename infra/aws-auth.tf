module "aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.8.4"

  cluster_name = module.eks.cluster_name

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::500662818810:role/ec2-connect"
      username = "ec2-connect"
      groups   = ["system:masters"]
    }
  ]
}
