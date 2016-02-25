resource "aws_eip" "jump" {
    instance = "${aws_instance.jump.id}"
    vpc = true
}


