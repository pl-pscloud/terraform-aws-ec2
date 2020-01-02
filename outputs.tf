output "pscloud_eip" {
  value = aws_eip.pscloud-eip[*].public_ip
}

output "pscloud_ip" {
  value = aws_instance.pscloud-ec2[*].public_ip
}

output "pscloud_ids" {
  value = aws_instance.pscloud-ec2[*].id
}