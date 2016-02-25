
resource "aws_subnet" "dmz" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.0.0/24"
	availability_zone = "${var.vpc_zone}"
	map_public_ip_on_launch = true
	tags {
		Name = "DMZ"
	}
}

resource "aws_subnet" "dmz_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.1.0/24"
	availability_zone = "${var.vpc_zone_alt}"
	map_public_ip_on_launch = true
	tags {
		Name = "DMZ-alt"
	}
}

resource "aws_subnet" "provision" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.96.0/24"
	availability_zone = "${var.vpc_zone}"
	tags {
		Name = "provision"
	}
}

resource "aws_subnet" "provision_alt" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.97.0/24"
	availability_zone = "${var.vpc_zone_alt}"
	tags {
		Name = "provision-alt"
	}
}

