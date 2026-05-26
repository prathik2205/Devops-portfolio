# 1. Dynamically find the latest official Ubuntu 24.04 Minimal AMI in ap-south-2
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-minimal/ubuntu-noble-24.04-amd64-*"]
  }
}

# 2. Build Firewall Rule Set
resource "aws_security_group" "portfolio_sg" {
  name        = "portfolio-security-group"
  description = "Allow inbound HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Create EC2 Host Instance
resource "aws_instance" "portfolio_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.portfolio_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io git
              sudo systemctl start docker
              sudo systemctl enable docker

              cd /home/ubuntu
              git clone https://github.com/prathik2205/Devops-portfolio.git
              
              cd Devops-portfolio
              sudo docker build -t live-portfolio .
              sudo docker run -d -p 80:80 --name prod-portfolio live-portfolio
              EOF

  tags = {
    Name = "DevOps-Portfolio-Instance"
  }
}

# 4. Expose Public Address Output
output "portfolio_public_url" {
  value       = "http://${aws_instance.portfolio_server.public_ip}"
  description = "The public URL of your live hosted portfolio website."
}