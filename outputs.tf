output "eip" {
  value = aws_eip.pscloud-eip[*].public_ip
}

output "ip" {
  value = aws_instance.pscloud-ec2[*].public_ip
}
