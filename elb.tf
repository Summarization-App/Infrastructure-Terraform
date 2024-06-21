# data "tls_certificate" "eks" {
#   url = module.eks.cluster_identity_providers.issuer
# }

# resource "aws_iam_openid_connect_provider" "eks" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
# #   url             = module.eks.identity[0].oidc[0].issuer
#     url = module.eks.cluster_identity_providers.issuer
# }

# module "lb_role" {
#   source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#   role_name = "my_eks_lb_role"
#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }
# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#     # cluster_ca_certificate = base64decode(module.eks.certificate_authority[0].data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
#       command     = "aws"
#     }
#   }
# }

# resource "helm_release" "aws_load_balancer_controller" {
#   name = "aws-load-balancer-controller"

#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   version    = "1.5.3"

#   set {
#     name  = "clusterName"
#     value = module.eks.cluster_name
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.aws_load_balancer_controller.arn
#   }

#   depends_on = [
#     # aws_eks_node_group.private_nodes,
#     aws_iam_role_policy_attachment.aws_load_balancer_controller_attach
#   ]
# }

# # resource "helm_release" "lb" {
# #   name       = "aws-load-balancer-controller"
# #   repository = "https://aws.github.io/eks-charts"
# #   chart      = "aws-load-balancer-controller"
# #   namespace  = "kube-system"
# #   depends_on = [
# #     kubernetes_service_account.service-account
# #   ]

# #   set {
# #     name  = "region"
# #     value = var.region
# #   }

# #   set {
# #     name  = "vpcId"
# #     value = module.vpc.vpc_id
# #   }

# #   set {
# #     name  = "image.repository"
# #     value = "602401143452.dkr.ecr.eu-west-2.amazonaws.com/amazon/aws-load-balancer-controller"
# #   }

# #   set {
# #     name  = "serviceAccount.create"
# #     value = "false"
# #   }

# #   set {
# #     name  = "serviceAccount.name"
# #     value = "aws-load-balancer-controller"
# #   }

# #   set {
# #     name  = "clusterName"
# #     value = module.eks.cluster_name
# #   }
# # }