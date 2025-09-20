output "cluster_name" { value = module.eks.cluster_name }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "region" { value = var.region }
output "private_subnets" { value = module.vpc.private_subnets }
