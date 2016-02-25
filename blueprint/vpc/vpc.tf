
provider "aws" {
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
	region = "${var.aws_region}"
}

resource "aws_vpc" "main" {
	cidr_block = "${var.vpc_cidr_block}"
	enable_dns_support = true

	tags {
		Name = "${var.aws_vpc_name}"
	}
}

resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "gw"
    }
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "${var.state_bucket}"
    acl = "private"
	region= "${var.aws_region}"
	#authenticated-read

    tags {
        Name = "terraform_state"
        Role= "terraform_state"
    }
}

##########################
# NATmain routing table NAT
##########################

resource "aws_route_table" "nat" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }

    tags {
        Name = "nat"
    }
}

resource "aws_main_route_table_association" "main" {
    vpc_id = "${aws_vpc.main.id}"
    route_table_id = "${aws_route_table.nat.id}"
}

############################
# DMZ routing
############################

resource "aws_route_table" "dmz" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }

    tags {
        Name = "dmz"
    }
}

# set the DMZ subnet to be connect to the internet
resource "aws_route_table_association" "dmz" {
    subnet_id = "${aws_subnet.dmz.id}"
    route_table_id = "${aws_route_table.dmz.id}"
}

# set the DMZ-alt subnet to be connect to the internet
resource "aws_route_table_association" "dmz_alt" {
    subnet_id = "${aws_subnet.dmz_alt.id}"
    route_table_id = "${aws_route_table.dmz.id}"
}


