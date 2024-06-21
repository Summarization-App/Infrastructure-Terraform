output "eks_init" {
  value       = "aws eks update-kubeconfig --name ${var.name} --region ${var.region}"
  description = "Run the following command to connect to the EKS cluster."
}