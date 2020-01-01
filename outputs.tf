output "eip_www" {
  value = aws_eip.eip_www[*].public_ip
}

output "ec2_ip_www" {
  value = aws_instance.pscloud-ec2[*].public_ip
}
