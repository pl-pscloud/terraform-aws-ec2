output "pscloud_ip" {
  value = (var.pscloud_eip_true ? aws_eip.pscloud-eip[*].public_ip : aws_instance.pscloud-ec2[*].public_ip)
}

output "pscloud_ids" {
  value = aws_instance.pscloud-ec2[*].id
}