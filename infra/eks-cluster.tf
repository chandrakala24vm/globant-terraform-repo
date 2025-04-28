module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = data.aws_subnets.default_public.ids

  enable_irsa = true
  create_cloudwatch_log_group = true

  tags = {
    cluster = "Globant"
  }
  
  vpc_id = data.aws_vpc.default.id

  cluster_addons = {
   aws-ebs-csi-driver= {}
   aws-efs-csi-driver={}
  }

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {
    node_group = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
      k8s_labels = {
        role = "worker"
      }
      additional_tags = {
        nodegroup-role                                  = "worker"
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
      }
        update_config = {
        max_unavailable_percentage = 50
      }
    }

  tags = {
    "k8s.io/cluster-autoscaler/enabled"             = "true"
    "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
  }
      ####################
  }
}

