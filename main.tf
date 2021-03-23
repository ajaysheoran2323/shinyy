provider "aws" {
  shared_credentials_file = "access"
  profile                 = "default"
  region                  =  var.region
}

resource "aws_ecs_cluster" "shiny-ecs-cluster" {
  name = "shiny"
  tags = {
    Name = "shiny"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "shiny-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
     	role       = aws_iam_role.ecs_task_execution_role.name
  	policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
	  name = "shiny-ecsTaskRole"

  	assume_role_policy = <<EOF
		{
 		"Version": "2012-10-17",
 		"Statement": [
  		 {
     		"Action": "sts:AssumeRole",
     		"Principal": {
      		 "Service": "ecs-tasks.amazonaws.com"
     		},
     		"Effect": "Allow"
   		}
	    ]
	}
	EOF
}


resource "aws_ecs_task_definition" "shiny_task_definition" {
  family = "service"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = [
    "FARGATE"]
  network_mode = "awsvpc"
  cpu = 512
  memory = 1024 
  container_definitions = jsonencode([
      {
	 "name":"shiny-app",
	 "image":var.shiny_image,
 	 "portMappings":[
         {
            "containerPort":80,
            "hostPort":80,
            "protocol":"tcp"
         }
        ],
	"environment":[
         {
		"name":"POSTGRES_USER",
                "value":aws_db_instance.rds_instance.username
	},
         {
            "name":"POSTGRES_PASSWORD",
            "value":aws_db_instance.rds_instance.password
	},
	{
            "name":"POSTGRES_ENDPOINT",
            "value": aws_db_instance.rds_instance.endpoint
	},
         {
            "name":"POSTGRES_DATABASE",
            "value": aws_db_instance.rds_instance.name
	}]
	}])
}

resource "aws_db_instance" "rds_instance" {
  identifier                  = var.rds_identifier
  allocated_storage           = var.rds_allocated_storage
  storage_type                = var.rds_storage_type
  multi_az                    = false
  engine                      = var.rds_engine
  engine_version              = var.rds_engine_version
  instance_class              = var.rds_instance_type
  name                        = var.rds_database_name
  username                    = var.rds_username
  password                    = var.rds_password
  port                        = "5432" 
  parameter_group_name        = "default.postgres12"
  auto_minor_version_upgrade  = false
  apply_immediately           = true
  storage_encrypted           = false
  skip_final_snapshot         = true
}
