data "local_file" "install_script"{
  filename = "install.sh"
}

resource "aws_instance" "web" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.large"
  vpc_security_group_ids = [aws_security_group.jenkin-vm-sg.id]
  key_name = "devops"
  user_data = data.local_file.install_script.content
  tags = {
    Name = "CI-CD-SONARQUBE-JENKINS"
  }
  root_block_device {
    volume_size = 30
  }
}

resource "aws_security_group" "jenkin-vm-sg" {
  name        = "jenkin-vm-sg"
  description = "Allow inbound traffic"

  ingress = [
    for port in [22,80,443,8080,9090,9100,9000,3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "jenkin-vm-sg"
  }
}

