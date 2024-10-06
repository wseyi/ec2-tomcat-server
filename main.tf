
# Create an S3 bucket for the state file
resource "aws_s3_bucket" "terraform_state" {
  bucket = "state-bucket"
}

# EC2 instance in the private subnet (running Tomcat)
resource "aws_instance" "private_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Install Java
              sudo yum update -y
              sudo amazon-linux-extras install java-openjdk11 -y

              # Install Tomcat
              sudo yum install tomcat -y
              sudo systemctl start tomcat
              sudo systemctl enable tomcat
              
              # Ensure Tomcat runs on startup
              sudo systemctl status tomcat
              EOF

  tags = {
    Name = "Tomcat-Private-Instance"
  }
}

# Security group allowing access to Tomcat (port 8080)
resource "aws_security_group" "tomcat_sg" {
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allow access only from within the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}