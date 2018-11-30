
# Global variables ==============================================================
variable "customer" { default = "kerkeni" }
variable "project" { default = "lbfronts" }
variable "platform" { default = "prod" }
variable "region" { default = "eu-west-3" } # Paris
variable "cidr_block" { default = "1" }
variable "ami_servers" {default = "ami-075b44448d2276521"} # Ubuntu Server 16.04 LTS (HVM), SSD Volume Type (Paris)
variable "ectype_fronts" {default = "t2.micro"}
# -- Veriables defined in private section
#variable "whiteListIPs" {default = "A.B.C.D/E"}


# Main regions
provider "aws" {
  region = "${var.region}"
}

# Credentials =============================================================
resource "aws_key_pair" "wke-deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCziY2Iv7bISA+YHULJsLZnqov+0bb7GnB5JY0U2Frwf0b/Exo39y5Djxc5MCuya11Y5VVzTruRHcHoUDeG4Ef9WmceV1qd8okttr6nayTsU4qI8rNiIJzIsKVMgWJCNRCM52lmvLNvaa+XdrGUrgNxUvuW52dnGiO/LGMismjGOPVy7lNiJMOjfDw9FN0rL5CkOTnh+5kBeDlv/8p3oOZ0lgHLr9AE4lf0B8tPBHYZZbCrQHh4j3HDiaxRZ5wkG0tZFw2xS6MYW48aUZ0kZxWkjqFBxXdUTfp6ccDgx1fX+/zRDI69ilDCKe8CuG+Eazi3h0/ooIW1BKyc9BvwdBI1 Wicem-KERKENI@WK-THINK"
}
