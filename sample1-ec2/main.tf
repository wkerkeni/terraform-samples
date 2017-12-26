# Configure the AWS Provider
# Paris data center not handled yet by terraform

# variables ==============================================================
variable "region" { default = "eu-west-1" }

# credentials ============================================================
provider "aws" {
  region     = "${var.region}"
}
# Ubuntu image  ==========================================================
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCziY2Iv7bISA+YHULJsLZnqov+0bb7GnB5JY0U2Frwf0b/Exo39y5Djxc5MCuya11Y5VVzTruRHcHoUDeG4Ef9WmceV1qd8okttr6nayTsU4qI8rNiIJzIsKVMgWJCNRCM52lmvLNvaa+XdrGUrgNxUvuW52dnGiO/LGMismjGOPVy7lNiJMOjfDw9FN0rL5CkOTnh+5kBeDlv/8p3oOZ0lgHLr9AE4lf0B8tPBHYZZbCrQHh4j3HDiaxRZ5wkG0tZFw2xS6MYW48aUZ0kZxWkjqFBxXdUTfp6ccDgx1fX+/zRDI69ilDCKe8CuG+Eazi3h0/ooIW1BKyc9BvwdBI1 Wicem-KERKENI@WK-THINK"
}

# VPC ==============================================================
resource "aws_vpc" "vpc01" {
 cidr_block = "10.1.0.0/16"
 tags {
   Name = "vpc_global"
  }
}
# Subnets ===========================================================
resource "aws_subnet" "vmtest-a" {
 vpc_id = "${aws_vpc.vpc01.id}"
 cidr_block = "10.1.0.0/23"
 availability_zone = "${var.region}a"
 map_public_ip_on_launch = true
 tags {
   Name = "subnet_vmtest_a"
 }
}
# routing ==============================================================
resource "aws_internet_gateway" "gw-to-internet01" {
 vpc_id = "${aws_vpc.vpc01.id}"
}

resource "aws_route_table" "route-to-gw01" {
 vpc_id = "${aws_vpc.vpc01.id}"
 route {
 cidr_block = "0.0.0.0/0"
   gateway_id = "${aws_internet_gateway.gw-to-internet01.id}"
 }
}
resource "aws_route_table_association" "vmtest-a" {
 subnet_id = "${aws_subnet.vmtest-a.id}"
 route_table_id = "${aws_route_table.route-to-gw01.id}"
}
# Security Group ===================================================
resource "aws_security_group" "sg_infra" {
 name = "sg_infra"
 description = "standard ssh &amp; monitoring"
 vpc_id = "${aws_vpc.vpc01.id}"

 tags {
   Name = "sg_infra"
 }

 ingress {
   from_port = 22
   to_port = 22
   protocol = "tcp"
   cidr_blocks = [
      "XX.XX.XX.XX/29"
   ]
 }

 ingress {
   from_port = -1
   to_port = -1
   protocol = "icmp"
   cidr_blocks = [
     "XX.XX.XX.XX/29"
   ]
 }
}
# Instance ====================================================
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "deployer-key"
  subnet_id = "${aws_subnet.vmtest-a.id}"
  security_groups = [
    "${aws_security_group.sg_infra.id}"
  ]
  tags {
    Name = "HelloWorld"
  }
}
