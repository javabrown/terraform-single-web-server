output "public_ip" {
  value = "${aws_instance.rk-tf-hello-instance.public_ip}"
}