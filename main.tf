provider "aws" {
  region = "ap-southeast-1"
}
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  tags = {
    Name = "myvpc"
  }
}
data "aws_availability_zones" "available" {}
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = { Name = "Public Subnet"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "Private Subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "Internet Gateway"
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "Route Table"
  }
}
resource "aws_route" "public_subnet_internet_gateway_ipv4" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "associate_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}
resource "aws_instance" "HelloWorld" {
  ami = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
  key_name = "MyKey"
  user_data = "${file("templates/helloworld.sh")}"
  timeouts {
    create = "3600s"
    update = "3600s"
    delete = "3600s"
  }
  tags = {
    Name = "HelloWorld"
  }
}
resource "aws_s3_bucket" "s3_terraform" {
  bucket = "terraformmys3"
  tags = {
    Name = "s3 terraform"
  }
}
resource "aws_s3_bucket_public_access_block" "s3_terraform_bucket_acl" {
bucket = aws_s3_bucket.s3_terraform.id
block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "s3_terraform_versioning" {
  bucket = aws_s3_bucket.s3_terraform.id
  versioning_configuration {
    status = "Enabled"
  }
}