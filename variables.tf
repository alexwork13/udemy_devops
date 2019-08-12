///  Profile  ///
variable "profile_name" { default = "palach" }
variable "aws_region" { default = "eu-west-1" }
variable "short_name" { default = "DevOpsDay" }

/// VPC ///
variable "vpc_cidr_range" {default = "10.0.0.0/16"}
variable "public_subnet_cidr1" {default = "10.0.0.0/24"}
variable "public_subnet_cidr2" {default = "10.0.10.0/24"}

