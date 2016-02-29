
############################
# NAT Instance
############################

resource "aws_instance" "nat" {
	instance_type = "m1.small"
	private_ip = "10.0.0.250"
	source_dest_check = false				#important for nat
	subnet_id = "${aws_subnet.dmz.id}"
	vpc_security_group_ids = ["${aws_security_group.nat.id}"]
	ami = "${lookup(var.nat_amis, var.aws_region)}"
	availability_zone = "${var.vpc_zone}"
	key_name = "${var.aws_keypair_name}"
	associate_public_ip_address = true

	root_block_device {
		delete_on_termination = true
	}

	tags {
		Name = "nat"
		Layer = "nat"
	}

	provisioner "local-exec" {
		command = "${path.module}/ansible/install-requirements.sh"
	}

	# wait until jump server is up
	provisioner "local-exec" {
		command = "sleep ${var.sleep_seconds}" #it takes a little while for the server to come up
	}

	# create tunnel 
	#provisioner "local-exec" {
	#	command = "ssh -i ${var.aws_private_key} -f -L 10250:${self.private_ip}:22 ec2-user@${aws_eip.jump.public_ip} -o StrictHostKeyChecking=no sleep ${var.ssh_wait_seconds} <&- >&- 2>&- &"
	#}

	connection {
		type = "ssh"
		private_key = "${var.aws_private_key}"
		user = "ec2-user"
		host = "${self.private_ip}"
		bastion_user = "ec2-user"
		bastion_host = "${aws_eip.jump.public_ip}"
		agent = false
	}

	#this is here because it is more resilent for the initial connect
	provisioner "remote-exec" {
		inline = [
			"echo connected"
		]
	}

	provisioner "local-exec" {
		command = "${path.module}/ansible/nat/run-play ${var.aws_private_key}"
	}

	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y"
		]
	}
}

resource "aws_instance" "provision" {
	depends_on = ["aws_route_table.nat", "aws_instance.nat"]
	instance_type = "t2.small"
	private_ip = "10.0.96.7"
	subnet_id = "${aws_subnet.provision.id}"
	vpc_security_group_ids = ["${aws_security_group.ssh_base.id}", "${aws_security_group.provision.id}"]
	ami = "${lookup(var.ubuntu_amis, var.aws_region)}"
	availability_zone = "${var.vpc_zone}"
	key_name = "${var.aws_keypair_name}"
	source_dest_check = true
	
	root_block_device {
		delete_on_termination = true
	}

	tags {
		Name = "provision"
		Layer = "provision"
	}

	provisioner "local-exec" {
		command = "${path.module}/ansible/install-requirements.sh"
	}

	# wait until jump server is up
	provisioner "local-exec" {
		command = "sleep ${var.sleep_seconds}" #it takes a little while for the server to come up
	}

	provisioner "local-exec" {
		command = "ssh -i ${var.aws_private_key} -f -L 12987:${self.private_ip}:22 ec2-user@${aws_eip.jump.public_ip} -o StrictHostKeyChecking=no sleep ${var.ssh_wait_seconds} <&- >&- 2>&- &"
	}

	connection {
		type = "ssh"
		user = "ubuntu"
		private_key = "${var.aws_private_key}"
		agent = false
		port = 12987
		host = "127.0.0.1"
	}

	#this is here because it is more resilent than file for the initial connect
	provisioner "remote-exec" {
		inline = [
			"echo connected"
		]
	}

	provisioner "file" {
		source = "${var.aws_private_key}"
		destination = "~/.ssh/current"
    }

	provisioner "remote-exec" {
		inline = [
			"chmod 600 ~/.ssh/current",
		]
	}

	provisioner "local-exec" {
		command = "${path.module}/ansible/provision/run-play ${var.aws_private_key}"
	}
}

resource "aws_instance" "jump" {
	depends_on = ["aws_internet_gateway.main"]
	instance_type = "t2.micro"
	private_ip = "10.0.0.7"
	subnet_id = "${aws_subnet.dmz.id}"
	vpc_security_group_ids = ["${aws_security_group.jump.id}"]
	ami = "${lookup(var.jump_amis, var.aws_region)}"
	availability_zone = "${var.vpc_zone}"
	source_dest_check = true
	associate_public_ip_address = true

	key_name = "${var.aws_keypair_name}" 

	root_block_device {
		delete_on_termination = true
	}
	tags {
		Name = "jump"
		Layer = "jump"
	}

	connection {
		type = "ssh"
		user = "ec2-user"
		private_key = "${var.aws_private_key}"
	}

	provisioner "local-exec" {
		command = "${path.module}/ansible/install-requirements.sh"
	}

	provisioner "local-exec" {
		command = "sleep ${var.sleep_seconds}" #it takes a little while for the server to come up
	}

	#this is here because it is more resilent than file for the initial connect
	provisioner "remote-exec" {
		inline = [
			"echo connected"
		]
	}

	provisioner "file" {
		source = "${var.aws_private_key}"
		destination = "~/.ssh/current"
    }

	provisioner "remote-exec" {
		inline = [
			"chmod 600 ~/.ssh/current"
		]
	}

	provisioner "local-exec" {
		command = "echo '${self.public_ip}' > ${path.module}/ansible/jump/inventory.ini"
	}

	provisioner "local-exec" {
		command = "${path.module}/ansible/jump/run-play ${var.aws_private_key}"
	}

	provisioner "remote-exec" {
		inline = [
			"echo connected"
		]
	}

	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y"
		]
	}

}


