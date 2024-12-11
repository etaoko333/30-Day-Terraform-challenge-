#Name: olusola-alonge
#Task Completed: Deploying a Single Server" and "Deploying a Web Server"
#Date: 11-12-24
##################

provider "aws" {
  region = "us-west-1"
}

# Security group resource
resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance resource
resource "aws_instance" "web_server" {
  ami           = "ami-0657605d763ac72a8"  # Replace with a valid Ubuntu AMI ID for the chosen region
  instance_type = "t2.micro"
  key_name      = "project"  # Use your existing key pair name
  security_groups = "aws_security_group.web_sg.id"  # Attach the security group

  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
}

# Output for the public IP
output "web_server_ip" {
  value = aws_instance.web_server.public_ip
}