# Update kubectl config map with cluster name
# do we really need?????
resource "null_resource" "merge_kubeconfig" {
  triggers = {
    always = timestamp()
  }

  depends_on = [module.eks]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      set -e
      echo 'Applying Auth ConfigMap with kubectl...'
      aws eks wait cluster-active --name '${module.eks.cluster_name}'
      aws eks update-kubeconfig --name '${module.eks.cluster_name}' --alias '${module.eks.cluster_name}-${var.region}' --region=${var.region}
    EOT
  }
}