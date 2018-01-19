# VPC ==============================================================
resource "aws_vpc" "vpc-sample2" {
 cidr_block = "10.${var.cidr_block}.0.0/16"
 tags {
   Name = "vpc_${var.customer}_${var.project}-${var.platform}"
   Customer = "${var.customer}"
   Platform = "${var.platform}"
 }
}