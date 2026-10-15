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
              set -euo pipefail

              sudo yum install -y docker git
              sudo systemctl enable --now docker
              sudo usermod -aG docker ec2-user

              git clone https://github.com/gabrielecirulli/2048.git /tmp/2048
              cd /tmp/2048

              cat > Dockerfile <<'DOCKERFILE'
              FROM nginx:alpine
              COPY . /usr/share/nginx/html
              DOCKERFILE

              printf '.git\nDockerfile\n.dockerignore\n' > .dockerignore

              docker build -t 2048-game .
              docker run -d \
                --name 2048-game-container \
                --restart unless-stopped \
                -p 80:80 \
                2048-game
            EOF
}

output "instance_public_ip" {
  value = aws_instance.server_2048.public_ip 
}