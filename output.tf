/*
output "ip-values-inst1" {
  value = aws_instance.my_webserver1.public_ip
}

output "ip-values-inst2"  {
  value = aws_instance.my_webserver2.public_ip
}
*/

output "aws_ami_id" {
  value = data.aws_ami.ami-linux2.id
}

output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}
