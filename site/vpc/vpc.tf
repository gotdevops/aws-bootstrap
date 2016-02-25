
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_account_id" {}

variable "aws_keypair_name" {}
variable "aws_vpc_name" {}
variable "aws_private_key" {}

variable "aws_region" {}
variable "vpc_zone" {}
variable "vpc_zone_alt" {}

variable "state_bucket" {}
variable "jump_access_cidr" {}

module "genesis" {
	source = "git::ssh://git@github.com/kraveio/aws-bootstrap//blueprint/vpc?ref=master"

	aws_access_key = "${var.aws_access_key}"
	aws_secret_key = "${var.aws_secret_key}"
	aws_account_id = "${var.aws_account_id}"

	aws_keypair_name = "${var.aws_keypair_name}"
	aws_vpc_name = "${var.aws_vpc_name}"
	aws_private_key = "${var.aws_private_key}"

	aws_region = "${var.aws_region}"
	vpc_zone = "${ var.vpc_zone}"
	vpc_zone_alt = "${var.vpc_zone_alt}"

	state_bucket= "${var.state_bucket}"

	jump_access_cidr = "${var.jump_access_cidr}"
	
}

output "vpc_id" {
    value = "${module.genesis.vpc_id}"
}

output "vpc_cidr_block" {
	value = "${module.genesis.vpc_cidr_block}"
}

output "vpc_zone" {
	value = "${module.genesis.vpc_zone}"
}
#
output "vpc_zone_alt" {
	value = "${module.genesis.vpc_zone_alt}"
}

output "sg_ssh_base" {
	value = "${module.genesis.sg_ssh_base}"
}

output "sg_provision" {
	value = "${module.genesis.sg_provision}"
}

output "sg_nat" {
	value = "${module.genesis.sg_nat}"
}

output "sg_jump" {
	value = "${module.genesis.sg_jump}"
}

output "sub_dmz" {
	value = "${module.genesis.sub_dmz}"
}

output "sub_dmz_alt" {
	value = "${module.genesis.sub_dmz_alt}"
}

output "jump_ip" {
	value = "${module.genesis.jump_ip}"
}

output "provision_ip" {
	value = "${module.genesis.provision_ip}"
}




