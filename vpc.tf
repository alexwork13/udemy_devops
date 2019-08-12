///  create VPC  ///
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_range
  enable_dns_hostnames = true

  tags = {
     Name = "${var.short_name}-vpc"
  }
}

///  Create public subnets  ///
data "aws_availability_zones" "vailability_zones" {}   /// data source of zone

/// 1st subnet  ///
resource "aws_subnet" "public1" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet_cidr1}"
  availability_zone = "${data.aws_availability_zones.vailability_zones.names[0]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.short_name}-public1"
  }
}

/// 2nd subnet  ///
resource "aws_subnet" "public2" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet_cidr2}"
  availability_zone = "${data.aws_availability_zones.vailability_zones.names[1]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.short_name}-public2"
  }
}

///  Create Internet Gateway  ///
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "${var.short_name}-gw"
  }
}

///  Route table  ///
resource "aws_route_table" "public1_rt1" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

   tags = {
    Name = "${var.short_name}-public_rt1"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id = "${aws_subnet.public1.id}"
  route_table_id = "${aws_route_table.public1_rt1.id}"
}

resource "aws_route_table_association" "public2" {
  subnet_id = "${aws_subnet.public2.id}"
  route_table_id = "${aws_route_table.public1_rt1.id}"
}


/// SG  ///
resource "aws_security_group" "public_sg" {
  name   = "public_sg"
  vpc_id = "${aws_vpc.main.id}"
  description = "public security group for EC2"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port         = 80
    to_port           = 80
    protocol          = "TCP"
    cidr_blocks       = ["0.0.0.0/0"]
  }

   ingress {
    from_port         = 443
    to_port           = 443
    protocol          = "TCP"
    cidr_blocks       = ["0.0.0.0/0"]
  }


  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server SecurityGroup"
    Owner = "Palach"
  }

}
