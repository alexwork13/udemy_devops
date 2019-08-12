resource "aws_iam_role" "s3fullaccess" {
  name = "s3fullaccess"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "s3fullaccess-role"
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "s3fullaccess-instance-profile"
  role = aws_iam_role.s3fullaccess.name
  depends_on = [aws_iam_role.s3fullaccess]
}

resource "aws_iam_role_policy_attachment" "policy_atachment" {
   role       = aws_iam_role.s3fullaccess.name
   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  depends_on = [aws_iam_role.s3fullaccess]
}