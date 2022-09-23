provider "aws" {
  region = lookup(var.awsprops, "region")
  # profile="prod" - specify the profile that is mentioned in ~/.aws/credenatials
}

resource "aws_instance" "instance" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  # iam_instance_profile        = "${var.iam-role-name != "" ? var.iam-role-name : ""}"
  user_data = "${var.user-data-script != "" ? file("${var.user-data-script}") : ""}"
  subnet_id = aws_subnet.subnet.id
  associate_public_ip_address = lookup(var.awsprops, "enable_publicip")
  key_name = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [
    aws_security_group.sg.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 10
    volume_type = "gp2"
  }
  tags = {
    Name = var.instance-tag-name
    Environment = "DEV"
    OS = "UBUNTU"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name = lookup(var.awsprops, "keyname")
  public_key = file(var.ssh_key_file)
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr-block
  enable_dns_hostnames = lookup(var.awsprops, "enable_dns")
  tags = {
    Name = var.vpc-tag-name
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.ig-tag-name
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet-cidr-block
  tags = {
    Name = var.subnet-tag-name
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
  name   = var.sg-tag-name
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ingress_ports
    iterator = port
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  # dynamic "egress" {
  #   for_each = var.egress_ports
  #   iterator = port
  #   content {
  #     from_port = port.value
  #     to_port = port.value
  #     protocol = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    to_port     = "0"
  }

  tags = {
    Name = var.sg-tag-name
  }
}