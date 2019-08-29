# Create internet and NAT gateways, subnets, attachments, etc. here.
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-internet-gateway"
  }
}

resource "aws_eip" "nat_gateway" {
  count = "${length(var.availability_zones)}"
  vpc   = true

  tags {
    Name = "${var.name}-NATGW-${element(var.availability_zone_names, count.index)}"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_nat_gateway" "main" {
  count         = "${length(var.availability_zones)}"
  allocation_id = "${element(aws_eip.nat_gateway.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_subnet" "public" {
  count             = "${length(var.availability_zones)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${var.cidr_prefix}.${count.index}.0/24"
  vpc_id            = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-public-${element(var.availability_zone_names, count.index)}"
  }
}

resource "aws_route" "public" {
  count                  = "${length(var.availability_zones)}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id         = "${element(aws_internet_gateway.main.*.id, count.index)}"
}

resource "aws_route_table" "public" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-routetable-public-${element(var.availability_zone_names, count.index)}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

# Backend subnets and routes
resource "aws_subnet" "private" {
  count             = "${length(var.availability_zones)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${var.cidr_prefix}.${count.index + 1 + 1}.0/24"
  vpc_id            = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-private-${element(var.availability_zone_names, count.index)}"
  }
}

resource "aws_route" "private" {
  count                  = "${length(var.availability_zones)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.main.*.id, count.index)}"
}

resource "aws_route_table" "private" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-routetable-private-${element(var.availability_zone_names, count.index)}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
