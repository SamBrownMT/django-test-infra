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

resource "aws_security_group" "postgres_sg" {
  ingress = {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_db_instance" "mysite" {
  allocated_storage    				= 2
  db_name              				= "mydb"
	db_subnet_group_name 				= aws_db_subnet_group.mysite.name
  engine              			  = "postgres"
  engine_version       				= "17.2"
  instance_class       				= "db.t3.micro"
  username             				= "foo"
	manage_master_user_password = true
  skip_final_snapshot  				= true
  vpc_security_group_ids = [ aws_security_group.postgres_sg.id ]
}

# resource "aws_security_group" "redis_sg" {
#   name        = "redis-security-group"
#   description = "Security group for Redis cluster"

#   ingress {
#     from_port   = 6379
#     to_port     = 6379
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  
#   }
# }

# resource "aws_elasticache_cluster" "mysite-redis" {
#   cluster_id           = "mysite"
#   engine               = "redis"
#   node_type            = "cache.t3.micro"  
#   num_cache_nodes      = 1
#   parameter_group_name = "default.redis7"  
#   engine_version       = "7.0"            
#   apply_immediately    = true
#   port                 = 6379

#   security_group_ids   = [aws_security_group.redis_sg.id] 
# }