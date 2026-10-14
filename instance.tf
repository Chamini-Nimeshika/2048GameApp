resource "aws_instance" "server_2048" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t3.micro"
  subnet_id     = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.sg_2048.id]
  associate_public_ip_address = true
  key_name = "2048keypair"

  tags = {
    Name = "server_2048"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx git
              sudo systemctl start nginx
              git clone https://github.com/gabrielecirulli/2048.git /tmp/2048
              sudo cp -r /tmp/2048/* /usr/share/nginx/html/
              sudo systemctl enable nginx
            EOF
}

output "instance_public_ip" {
  value = aws_instance.server_2048.public_ip 
}