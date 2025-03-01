resource "aws_instance" "app_server" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.medium"
  key_name      = var.key_name

  security_groups = [aws_security_group.app_sg.name]

  root_block_device {
    volume_size = 30  # Set root volume to 30GB
    volume_type = "gp3"
  }

  tags = {
    Name = var.server_name
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y python3 python3-pip
              EOF
}

resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for DevOps Stage 4 app"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory/hosts.ini"
  content  = <<-EOT
    [web]
    ${aws_instance.app_server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/${var.key_name}.pem
  EOT
}
