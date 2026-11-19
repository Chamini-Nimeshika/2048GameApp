resource "aws_instance" "server_2048" {
  ami                         = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type               = "t3.micro"
  subnet_id                   = aws_default_subnet.default_az1.id
  vpc_security_group_ids      = [aws_security_group.sg_2048.id]
  associate_public_ip_address = true
  key_name                    = "2048keypair"
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm.name

  tags = {
    Name = "server_2048"
  }

  user_data = <<-EOF
              #!/bin/bash
              set -euo pipefail

              dnf install -y docker
              systemctl enable --now docker
              usermod -aG docker ec2-user

              docker run -d \
                --name 2048-game-container \
                --restart unless-stopped \
                -p 80:80 \
                ${var.container_image}
            EOF
}

output "instance_public_ip" {
  value = aws_instance.server_2048.public_ip
}