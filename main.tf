resource "aws_instance" "pscloud-ec2" {
  count = var.pscloud_instance_count

  ami           = var.pscloud_instance_ami
  key_name      = var.pscloud_key_name
  instance_type = var.pscloud_instance_type

  subnet_id              = var.pscloud_subnet_id
  vpc_security_group_ids = var.pscloud_sec_gr

  private_ip = var.pscloud_private_ip

  root_block_device {
    volume_type           = var.pscloud_root_volume_type
    volume_size           = var.pscloud_root_volume_size
    encrypted             = var.pscloud_root_volume_encrypted
    kms_key_id            = var.pscloud_kms_key_id
    delete_on_termination = true
  }

  monitoring = var.pscloud_monitoring

  tags = {
    Name    = "${var.pscloud_company}_ec2_${var.pscloud_env}_${var.pscloud_project}"
    Project = var.pscloud_project
  }

  volume_tags = {
    Name    = "${var.pscloud_company}_ebs_${var.pscloud_env}_${var.pscloud_project}"
    Project = var.pscloud_project
  }

}

resource "null_resource" "pscloud-provisioner-ssh" {
  count = (var.pscloud_provisioner_ssh == true) ? 1 : 0

  provisioner "remote-exec" {
    inline = [
      "echo 'EC2 runing'",
    ]
  }

  connection {
    type        = "ssh"
    host        = aws_instance.pscloud-ec2[0].public_ip
    user        = "ubuntu"
    private_key = file(var.pscloud_remote_exec_key)
    agent       = false
  }

  provisioner "local-exec" {
    command = "echo 'EC2 runing'"
  }

  depends_on = [aws_instance.pscloud-ec2]
}

resource "aws_eip" "pscloud-eip" {
  count = (var.pscloud_eip_true == true ? length(aws_instance.pscloud-ec2) : 0)

  vpc                       = true
  instance                  = aws_instance.pscloud-ec2[count.index].id
  associate_with_private_ip = aws_instance.pscloud-ec2[count.index].private_ip

  tags = {
    Name = "${var.pscloud_company}_eip_www_${var.pscloud_env}_${var.pscloud_project}"
  }
}

data "template_file" "ec2tpl" {
  template = file("../ansible/templates/inventory.tpl")
  vars = {
    ec2name = var.pscloud_project
    ec2ip   = (var.pscloud_eip_true == true ? (join("\n", aws_eip.pscloud-eip.*.public_ip)) : (join("\n", aws_instance.pscloud-ec2.*.public_ip)))
  }
}

resource "local_file" "ec2tpl_file" {
  content  = data.template_file.ec2tpl.rendered
  filename = "../ansible/inventory/ec2-host-${var.pscloud_env}-${var.pscloud_project}"

  depends_on = [
    aws_eip.pscloud-eip, aws_instance.pscloud-ec2,
  ]

}