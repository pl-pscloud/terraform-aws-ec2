variable "pscloud_env" {}
variable "pscloud_company" {}
variable "pscloud_key_name" {}
variable "pscloud_purpose" {}
variable "pscloud_instance_count" {}
variable "pscloud_instance_type" {}
variable "pscloud_instance_ami" {}
variable "pscloud_subnet_id" {}
variable "pscloud_sec_gr" {}
variable "pscloud_eip_true" { default = false}
variable "pscloud_private_ip" { default = "" }
variable "pscloud_remote_exec_key" {}
variable "pscloud_monitoring" { default = false}
variable "pscloud_root_volume_size" { default = 10 }
variable "pscloud_root_volume_type" { default = "gp2" }


//variable "pscloud_elb_target_group" {}
//variable "pscloud_instance_spot_price" {}


