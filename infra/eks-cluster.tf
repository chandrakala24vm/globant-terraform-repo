module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  vpc_id          = module.vpc.vpc_id

  authentication_mode = "API_AND_CONFIG_MAP"

  enable_irsa                     = true
  create_cloudwatch_log_group     = true
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access  = true

  tags = {
    cluster = "Globant"
  }

  cluster_addons = {
    aws-ebs-csi-driver = {}
    aws-efs-csi-driver = {}
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
  }

  access_entries = {
    terraform-demo = {
      principal_arn     = "arn:aws:iam::500662818810:user/terraform-demo"
      kubernetes_groups = ["system:masters"]
    }
  }
}
