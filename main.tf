resource "aws_instance" "pscloud-ec2" {
  count = var.pscloud_instance_count

  ami = var.pscloud_instance_ami
  key_name = var.pscloud_key_name
  instance_type = var.pscloud_instance_type

  subnet_id = var.pscloud_public_subnets_id
  vpc_security_group_ids = [
    var.pscloud_sec_gr
  ]

  root_block_device {
    volume_type = "gp2"
    volume_size = 10
    delete_on_termination = true
  }

  monitoring = var.pscloud_monitoring

  tags = {
    Name = "${var.pscloud_company}_ec2_${var.pscloud_env}"
    Purpose = "${var.pscloud_company}_ec2_${var.pscloud_env}_${var.pscloud_purpose}"
  }

  provisioner "remote-exec" {
    inline = [
    "echo 'EC2 runing'",
    ]
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user  = "ubuntu"
    private_key = file(var.pscloud_remote_exec_key)
    agent = false
  }

  provisioner "local-exec" {
    command = "echo 'EC2 runing'"
  }
}

resource "aws_eip" "pscloud-eip" {
  count = (var.pscloud_eip_true == true ? length(aws_instance.pscloud-ec2) : 0)

  vpc = true
  instance                  = aws_instance.pscloud-ec2[count.index].id
  associate_with_private_ip = aws_instance.pscloud-ec2[count.index].private_ip

  tags = {
    Name = "${var.pscloud_company}_eip_www_${var.pscloud_env}"
  }
}

data  "template_file" "ec2tpl" {
  template = file("../ansible/templates/inventory.tpl")
  vars = {
      ec2name = var.pscloud_purpose
      ec2ip = (var.pscloud_eip_true == true ? (join("\n", aws_eip.pscloud-eip.*.public_ip)) : (join("\n", aws_instance.pscloud-ec2.*.public_ip)))
  }
}

resource "local_file" "ec2tpl_file" {
  content  = data.template_file.ec2tpl.rendered
  filename = "../ansible/inventory/ec2-host-${var.pscloud_env}-${var.pscloud_purpose}"

  depends_on = [
    aws_eip.pscloud-eip, aws_instance.pscloud-ec2,
  ]

}