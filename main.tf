# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A SINGLE EC2 INSTANCE
# This template uses runs a simple "Hello, World" web server on a single EC2 Instance
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A SINGLE EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "rk-tf-hello-instance" {
  # Ubuntu Server 14.04 LTS (HVM), SSD Volume Type in us-east-1
  #ami = "ami-2d39803a"
  
  # Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type - ami-0756fbca465a59a30 in us-east-1
  ami = "ami-0756fbca465a59a30"  
  
  instance_type = "t2.micro"
  key_name = "rk-ec2-keypair-1"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y

              #Install Docker
              sudo yum update -y
              sudo yum install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user

              #Install GIT
              sudo yum -y install git

              #Install HTTPD
              #sudo yum clean all
              #sudo yum -y update
              #sudo yum -y install httpd
              #sudo chkconfig httpd on
              #sudo /etc/init.d/httpd start

              #echo "Hello, World" > index.html
              #nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags {
    Name = "terraform-rk-tf-hello-instance"
  }


    #-----------------REMOTE EXEC-BEGIN---------------
    provisioner "remote-exec" {
        inline = [
          "export PATH=$PATH:/usr/bin",
          "sudo yum clean all",
          "sudo yum -y update",
          "sudo yum -y install httpd24",
          "sudo /etc/init.d/httpd start",

          "sudo wget https://raw.githubusercontent.com/javabrown/terraform_aws_single-web-server/amazon-linux-ec2-sites/web-config/rk.conf -O /etc/httpd/conf.d/rk.conf",

          "sudo mkdir /var/www/gahmar",

          "sudo mkdir /var/www/bjpindia",

          "sudo wget https://raw.githubusercontent.com/javabrown/terraform_aws_single-web-server/amazon-linux-ec2-sites/web-config/site-1/index.html -O /var/www/gahmar/index.html",

          "sudo wget https://raw.githubusercontent.com/javabrown/terraform_aws_single-web-server/amazon-linux-ec2-sites/web-config/site-2/index.html -O /var/www/bjpindia/index.html",

          "sudo service httpd restart",

          "sleep .10",

          "sudo service httpd restart"
        ]
    }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = ""
    private_key = "${file("~/projects/rk-ec2-keypair-1.pem")}"
  }
    #-----------------REMOTE EXEC-END-----------------

}


# ---------------------------------------------------------------------------------------------------------------------
# ELASTIC IP ASSOCIATION
# ---------------------------------------------------------------------------------------------------------------------
#resource "aws_eip_association" "eip_assoc" {
#  instance_id   = "${aws_instance.rk-tf-hello-instance.id}"
#  allocation_id = "${aws_eip.rk-tf-hello-eip.id}"
#}

#resource "aws_eip" "rk-tf-hello-eip" {
#  vpc = true
#}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SECURITY GROUP THAT'S APPLIED TO THE EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "instance" {
  name = "terraform-rk-tf-hello-instance"

  # Inbound HTTP from anywhere
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //SSH Client
  ingress {
      from_port = "22"
      to_port = "22"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }


      # Allow all inbound
        ingress {
          from_port   = 0
          to_port     = 65535
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }

        egress {
          from_port   = 0
          to_port     = 65535
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
}


