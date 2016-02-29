
############################
# REQUIRED
############################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_account_id" {}

variable "aws_vpc_name" {}
variable "aws_keypair_name" {}
variable "aws_private_key" {}

#maybe prefix vpc_id on some root?
variable "state_bucket" {}

############################
# DEFAULTS
############################
variable "aws_region" {
	default = "us-west-2"
}

variable "vpc_zone" {
	default = "us-west-2a"
}

variable "vpc_zone_alt" {
	default = "us-west-2b"
}

variable "vpc_cidr_block" {
	default = "10.0.0.0/16"
}

variable "jump_access_cidr" {
	default = "0.0.0.0/0" # use + to delimit more
}

variable "sleep_seconds" {
	default = "90"
}

variable "ssh_wait_seconds" {
	default = "512"
}


############################
# LOOKUP
############################

variable "nat_amis" {
	default = {
		us-west-2 = "ami-49691279"
	}
}

variable "jump_amis" {
	default = {
		us-west-2 = "ami-d13845e1"
	}
}

variable "ubuntu_amis" {
	default = {
		us-east-1 = "ami-aa7ab6c2" #ubuntu
		us-west-2 = "ami-5189a661" #ubuntu
	}
}

############################
# OUTPUT
############################

output "vpc_id" {
    value = "${aws_vpc.main.id}"
}

output "vpc_cidr_block" {
	value = "${var.vpc_cidr_block}"
}

output "vpc_zone" {
	value = "${var.vpc_zone}"
}

output "vpc_zone_alt" {
	value = "${var.vpc_zone_alt}"
}

output "sg_ssh_base" {
	value = "${aws_security_group.ssh_base.id}"
}

output "sg_provision" {
	value = "${aws_security_group.provision.id}"
}

output "sg_nat" {
	value = "${aws_security_group.nat.id}"
}

output "sg_jump" {
	value = "${aws_security_group.jump.id}"
}

output "sub_dmz" {
	value = "${aws_subnet.dmz.id}"
}

output "sub_dmz_alt" {
	value = "${aws_subnet.dmz_alt.id}"
}

output "jump_ip" {
	value = "${aws_instance.jump.public_ip}"
}

output "provision_ip" {
	value = "${aws_instance.provision.private_ip}"
}


