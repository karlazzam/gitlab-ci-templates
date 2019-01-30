resource "aws_instance" "example" {
  ami           = "ami-cc7551a9"
  instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}
