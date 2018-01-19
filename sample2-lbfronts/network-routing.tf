# routing ==============================================================
resource "aws_internet_gateway" "gw-to-internet-sample2" {
 vpc_id = "${aws_vpc.vpc-sample2.id}"
}

resource "aws_route_table" "route-to-gw-sample2" {
 vpc_id = "${aws_vpc.vpc-sample2.id}"
 route {
 cidr_block = "0.0.0.0/0"
   gateway_id = "${aws_internet_gateway.gw-to-internet-sample2.id}"
 }
}

resource "aws_route_table_association" "front-a" {
 subnet_id = "${aws_subnet.front-a.id}"
 route_table_id = "${aws_route_table.route-to-gw-sample2.id}"
}

resource "aws_route_table_association" "front-b" {
 subnet_id = "${aws_subnet.front-b.id}"
 route_table_id = "${aws_route_table.route-to-gw-sample2.id}"
}