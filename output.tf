
output "hsm_ip_address" {
  value = aws_cloudhsm_v2_hsm.hsm.*.ip_address
}

output "hsm_id" {
  value = aws_cloudhsm_v2_hsm.hsm.*.id
}

output "hsm_eni_id" {
  value = aws_cloudhsm_v2_hsm.hsm.*.hsm_eni_id
}

output "hsm_state" {
  value = aws_cloudhsm_v2_hsm.hsm.*.hsm_state
}

output "cluster_data_certificate" {
  value = aws_cloudhsm_v2_cluster.cloudhsm_cluster.*.cluster_certificates
}

output "cluster_id" {
  value = aws_cloudhsm_v2_cluster.cloudhsm_cluster.*.cluster_id
}

output "cluster_state" {
  value = aws_cloudhsm_v2_cluster.cloudhsm_cluster.*.cluster_state
}

