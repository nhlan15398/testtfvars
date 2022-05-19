output "vpc_id" {
  value = aws_vpc.main.id
}
output "security_group_id" {
  value = aws_security_group.allow_http_ssh.id
}
output "private_subnet_ids" {
  value = aws_subnet.private_subnet.id
}
output "public_subnet_ids" {
  value = aws_subnet.public_subnet.id
}
output "aws_internet_gateway" {
  value = aws_internet_gateway.igw.id
}
output "aws_route_table" {
  value = aws_route_table.route_table.id
}
output "aws_s3_bucket" {
  value = aws_s3_bucket.s3_terraform.id
}