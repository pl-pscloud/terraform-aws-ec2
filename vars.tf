variable "pscloud_env" {}
variable "pscloud_company" {}
variable "pscloud_key_name" {}
variable "pscloud_project" {}
variable "pscloud_instance_count" {}
variable "pscloud_instance_type" {}
variable "pscloud_instance_ami" {}
variable "pscloud_subnet_id" {}
variable "pscloud_sec_gr" {}
variable "pscloud_eip_true" { default = false}
variable "pscloud_private_ip" { default = "" }
variable "pscloud_instance_profile" { default = "" }
variable "pscloud_remote_exec_key" {}
variable "pscloud_monitoring" { default = false}
variable "pscloud_root_volume_type" { default = "gp2" }
variable "pscloud_root_volume_size" { default = 10 }
variable "pscloud_root_volume_encrypted" { default = "false" }
variable "pscloud_kms_key_id" { default = ""}
variable "pscloud_ebs_optimized" { default = false }

variable "pscloud_provisioner_ssh" { default = false}
variable "pscloud_ansible" { default = true}

variable "pscloud_ebs_volumes" {
  type = list(object({
    type      = string
    size      = string
    encrypted = string
  }))
  default = []
}



//variable "pscloud_elb_target_group" {}
//variable "pscloud_instance_spot_price" {}


