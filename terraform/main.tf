terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-2"
}

resource "aws_db_subnet_group" "mysite" {
  name       = "samb-mysite"
  subnet_ids = ["subnet-05ca3989beebc3eae", "subnet-0415a4fe64af33ef3"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "mysite" {
  allocated_storage    				= 10
  db_name              				= "mydb"
	db_subnet_group_name 				= aws_db_subnet_group.mysite.name
  engine              			  = "postgres"
  engine_version       				= "17.2"
  instance_class       				= "db.t3.micro"
  username             				= "foo"
	manage_master_user_password = true
  skip_final_snapshot  				= true
}