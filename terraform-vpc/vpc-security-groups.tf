resource "aws_security_group" "jump" {
	vpc_id = "${aws_vpc.main.id}"
	name = "jump"
	description = "A jump server"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${split(",",var.jump_access_cidr)}"]
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		security_groups = ["${aws_security_group.provision.id}"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "ssh_base" {
	vpc_id = "${aws_vpc.main.id}"
	name = "ssh-base"
	description = "Allow SSH access from the jump server"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		security_groups = ["${aws_security_group.jump.id}",
						"${aws_security_group.provision.id}"]
	}

	ingress {
		from_port = -1
		to_port = -1
		protocol = "icmp"
		cidr_blocks = ["${var.vpc_cidr_block}"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "nat" {
	vpc_id = "${aws_vpc.main.id}"
	name = "nat"
	description = "For nat servers "

#	ingress {
#		from_port = 22
#		to_port = 22
#		protocol = "tcp"
#		security_groups = ["${aws_security_group.jump.id}"]
#	}
#
#	ingress {
#		from_port = 22
#		to_port = 22
#		protocol = "tcp"
#		security_groups = ["${aws_security_group.provision.id}"]
#	}
#
#	ingress {
#		from_port = 23
#		to_port =  65535
#		protocol = "tcp"
#		security_groups = ["${aws_security_group.ssh_base.id}"]
#	}
#
#	ingress {
#		from_port = -1
#		to_port = -1
#		protocol = "icmp"
#		security_groups = ["${aws_security_group.ssh_base.id}"]
#	}
#
#	ingress {
#		from_port = 23
#		to_port =  65535
#		protocol = "udp"
#		security_groups = ["${aws_security_group.ssh_base.id}"]
#	}

	ingress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["${var.vpc_cidr_block}"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "provision" {
	vpc_id = "${aws_vpc.main.id}"
	name = "provision_server"
	description = "Provisioning servers"
}

