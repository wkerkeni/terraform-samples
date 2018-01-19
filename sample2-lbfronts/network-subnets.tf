# front subnets ==============================================================
resource "aws_subnet" "front-a" {
 vpc_id = "${aws_vpc.vpc-sample2.id}"
 cidr_block = "10.${var.cidr_block}.0.0/23"
 availability_zone = "${var.region}a"
 map_public_ip_on_launch = true
 tags {
   Name = "subnet_${var.customer}_${var.project}-${var.platform}_front_a"
   Customer = "${var.customer}"
   Platform = "${var.platform}"
 }
}

resource "aws_subnet" "front-b" {
 vpc_id = "${aws_vpc.vpc-sample2.id}"
 cidr_block = "10.${var.cidr_block}.2.0/23"
 availability_zone = "${var.region}b"
 map_public_ip_on_launch = true
 tags {
   Name = "subnet_${var.customer}_${var.project}-${var.platform}_front_b"
   Customer = "${var.customer}"
   Platform = "${var.platform}"
 }
}