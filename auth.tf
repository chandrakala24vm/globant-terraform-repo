provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.eks.name
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.worker.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::500662818810:root"
        username = "root"
        groups   = ["system:masters"]
      }
    ])
  }
  depends_on = [aws_eks_node_group.node-grp]
}