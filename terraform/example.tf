resource "aws_instance" "example" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}
