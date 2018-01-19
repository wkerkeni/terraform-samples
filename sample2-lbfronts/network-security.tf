# public security groups =======================================================
# This is used to LoadBlancer
resource "aws_security_group" "sg_public_service" {
 name = "sg_${var.customer}_${var.project}-${var.platform}_public_service"
 description = "Allow http inbound traffic AND Outbount for health check"
 vpc_id = "${aws_vpc.vpc-sample2.id}"

 tags {
   Name = "sg_${var.customer}_${var.project}-${var.platform}_public_service"
   Customer = "${var.customer}"
   Platform = "${var.platform}"
 }

 ingress {
   from_port = 80
   to_port = 80
   protocol = "tcp"
   cidr_blocks = ["${var.whiteListIPs}"]
 }
 egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# front security groups ==============================================================
resource "aws_security_group" "sg_front_service" {
 name = "sg_${var.customer}_${var.project}-${var.platform}_front_service"
 description = "Allow http inbound traffic from the public service sg; all inside the SG"
 vpc_id = "${aws_vpc.vpc-sample2.id}"
 tags {
    Name = "sg_${var.customer}_${var.project}-${var.platform}_front_service"
    Customer = "${var.customer}"
    Platform = "${var.platform}"
 }

 ingress {
   from_port = 80
   to_port = 80
   protocol = "tcp"
   security_groups = [
     "${aws_security_group.sg_public_service.id}"
   ]
 }

 ingress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   self = "true"
 }
 
}
resource "aws_security_group" "sg_infra" {
 name = "sg_${var.customer}_${var.project}-${var.platform}_infra"
 description = "Standard ssh &amp; monitoring &amp; all outbound traffic"
 vpc_id = "${aws_vpc.vpc-sample2.id}"

 tags {
   Name = "sg_${var.customer}_${var.project}-${var.platform}_infra"
   Customer = "${var.customer}"
   Platform = "${var.platform}"
 }
 ingress {
   from_port = 22
   to_port = 22
   protocol = "tcp"
   cidr_blocks = ["${var.whiteListIPs}"]
 }
 ingress {
   from_port = -1
   to_port = -1
   protocol = "icmp"
   cidr_blocks = ["${var.whiteListIPs}"]
 }
 egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
