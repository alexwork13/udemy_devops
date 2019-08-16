resource "aws_key_pair" "my-test-key" {
  key_name   = "ubuntu1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTX6JKLZwjbRKsN4LrjlBVXXEMuhVpzObfo/LssxSyAp+8AuEp1w8+gVTqo8ekLs6QfnsUyuxCiQ0gBlVO39bzKT4RvIb3ME8jJ9cHT0sSFUajwCWPsrNjdupM9FDOg7KJKJGrKnKTYrcrhVB8vOY9GkwdgzgYFTvQbETDAQns94+Xq8jO8vUFeKAJGYpCcOBOJ7Oqn+K7HAXzn0utlWfgTMDWNIYfsxn4BLaCp84ovQ/Dk/lrPJLyEgO9ENCBHIvmpvYr7oyTKdYWEXn7I6/DPzSVTzDOQIhzv6w8SKjDpICf19DGGb9fvMbZN83owTLWkoZzat33Ygnjj0K5cGFH alex@HP"
}

data "aws_ami" "ami-linux2" {
  most_recent = true
  owners = [
    "137112412989"]

  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}


resource "aws_instance" "my_webserver1" {
  ami                    = data.aws_ami.ami-linux2.id
  instance_type          = "t2.micro"
  iam_instance_profile   = "${aws_iam_instance_profile.instance_profile.id}"
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  user_data              =  templatefile("./data/user_data.sh.tpl", {
        number="web1",
        name="test1"
  })
  subnet_id              = "${aws_subnet.public1.id}"
  key_name               = "${aws_key_pair.my-test-key.key_name}"

  tags = {
    Name  = "Web Server 1 Build by Terraform"
    Owner = "Alexander Palazchenko"
  }
  depends_on = [aws_iam_role.s3fullaccess]  //aws_s3_bucket_object.object,
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "my_webserver2" {
  ami                    = data.aws_ami.ami-linux2.id
  instance_type          = "t2.micro"
  iam_instance_profile   = "${aws_iam_instance_profile.instance_profile.id}"
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  user_data              = templatefile("./data/user_data.sh.tpl", {
        number="web2",
        name="test2"
  })
  subnet_id              = "${aws_subnet.public2.id}"
  key_name               = "${aws_key_pair.my-test-key.key_name}"

  tags = {
    Name  = "Web Server 2 Build by Terraform"
    Owner = "Alexander Palazchenko"
  }

  depends_on = [aws_iam_role.s3fullaccess]   //aws_s3_bucket_object.object,
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "for_web1" {
  instance = "${aws_instance.my_webserver1.id}"
  depends_on = [aws_instance.my_webserver1]
}

resource "aws_eip" "for_web2" {
  instance = aws_instance.my_webserver2.id
  depends_on = [aws_instance.my_webserver2]
}