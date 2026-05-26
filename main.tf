# 1. Dynamically find the latest official Ubuntu 24.04 LTS image
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ==================== CUSTOM NETWORK INFRASTRUCTURE ====================

# 2. Create a dedicated VPC for your Portfolio
resource "aws_vpc" "portfolio_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "portfolio-custom-vpc" }
}

# 3. Create a Public Subnet inside our VPC
resource "aws_subnet" "portfolio_subnet" {
  vpc_id                  = aws_vpc.portfolio_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-2a"
  map_public_ip_on_launch = true # This assigns a public IP to your server

  tags = { Name = "portfolio-public-subnet" }
}

# 4. Create an Internet Gateway so the server can talk to the public web
resource "aws_internet_gateway" "portfolio_igw" {
  vpc_id = aws_vpc.portfolio_vpc.id

  tags = { Name = "portfolio-gateway" }
}

# 5. Create a Route Table mapping traffic to the Internet Gateway
resource "aws_route_table" "portfolio_rt" {
  vpc_id = aws_vpc.portfolio_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.portfolio_igw.id
  }

  tags = { Name = "portfolio-route-table" }
}

# 6. Associate the Route Table with our Subnet
resource "aws_route_table_association" "portfolio_rta" {
  subnet_id      = aws_subnet.portfolio_subnet.id
  route_table_id = aws_route_table.portfolio_rt.id
}

# ==================== FIREWALL & SECURITY GROUPS ====================

# 7. Build Firewall Rule Set attached to our Custom VPC
resource "aws_security_group" "portfolio_sg" {
  name        = "portfolio-production-sg"
  description = "Allow inbound HTTP and SSH traffic"
  vpc_id      = aws_vpc.portfolio_vpc.id

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

  tags = { Name = "portfolio-sg" }
}

# ==================== EC2 COMPUTE INSTANCE ====================

# 8. Create the EC2 Host Instance inside our custom subnet
resource "aws_instance" "portfolio_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.portfolio_subnet.id
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

  tags = { Name = "DevOps-Portfolio-Instance" }
}

# 9. Expose Public Address Output
output "portfolio_public_url" {
  value       = "http://${aws_instance.portfolio_server.public_ip}"
  description = "The public URL of your live hosted portfolio website."
}
