data "aws_availability_zones" "AZ" {}

resource "aws_vpc" "myVpc" {

  cidr_block       = "172.16.0.0/16"

  instance_tenancy = "default"

  enable_dns_hostnames = true

  enable_dns_support = true

  tags = {

    Name = "myVpc-calif"

    Location = "california"

  }

}

resource "aws_subnet" "public_subnet" {

  count = "${length(data.aws_availability_zones.AZ.names)}"

  vpc_id = "${aws_vpc.myVpc.id}"

  cidr_block = "172.16.${10+count.index}.0/24"

  availability_zone = "${data.aws_availability_zones.AZ.names[count.index]}"

  map_public_ip_on_launch = true

  tags = {

    Name = "MyPublicSubnet-${10+count.index}"

  }

}

resource "aws_subnet" "private_subnet" {

  count = "${length(data.aws_availability_zones.AZ.names)}"

  vpc_id = "${aws_vpc.myVpc.id}"

  cidr_block = "172.16.${20+count.index}.0/24"

  availability_zone= "${data.aws_availability_zones.AZ.names[count.index]}"

  map_public_ip_on_launch = false

  tags = {

    Name = "MyPrivateSubnet-${20+count.index}"

  }

}