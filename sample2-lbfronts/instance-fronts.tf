# EC2 ==============================================================
resource "aws_instance" "instance-front01-a" {
 ami = "${var.ami_servers}"
 instance_type = "${var.ectype_fronts}"
 key_name = "deployer-key"
 availability_zone = "${var.region}a"
 subnet_id = "${aws_subnet.front-a.id}"
 security_groups = [
   "${aws_security_group.sg_front_service.id}",
   "${aws_security_group.sg_infra.id}"
 ]
 associate_public_ip_address = true

 tags {
   Name = "web01-${var.platform}-${var.customer}"
   Customer = "${var.customer}"
   Platform = "${var.platform}"
 }

 root_block_device {
   volume_type = "gp2"
   volume_size = "10"
   delete_on_termination = "true"
 }
}

resource "aws_instance" "instance-front02-b" {
 ami = "${var.ami_servers}"
 instance_type = "${var.ectype_fronts}"
 key_name = "deployer-key"
 availability_zone = "${var.region}b"
 subnet_id = "${aws_subnet.front-b.id}"
 security_groups = [
   "${aws_security_group.sg_front_service.id}",
   "${aws_security_group.sg_infra.id}"
 ]
 associate_public_ip_address = true

 tags {
   Name = "web02-${var.platform}-${var.customer}"
   Customer = "${var.customer}"
   Platform = "${var.platform}"
 }

 root_block_device {
   volume_type = "gp2"
   volume_size = "10"
   delete_on_termination = "true"
 }
}


# ELB ==============================================================
resource "aws_elb" "lb-publicweb" {
 name = "elb-${var.customer}-${var.project}-${var.platform}-web"

 listener {
   lb_port = 80
   lb_protocol = "http"
   instance_port = 80
   instance_protocol = "http"
 }

 subnets = ["${aws_subnet.front-a.id}","${aws_subnet.front-b.id}"]
 security_groups = ["${aws_security_group.sg_public_service.id}"]
 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 2
   timeout = 3
   target = "TCP:80"
   interval = 30
 }

 instances = ["${aws_instance.instance-front01-a.id}","${aws_instance.instance-front02-b.id}"]
}
