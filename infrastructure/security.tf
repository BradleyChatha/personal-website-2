// Defines security-related resources
resource "aws_key_pair" "terraform" {
  key_name   = "terraform"
  public_key = file("${path.module}/private/public.pem")
}

resource "aws_security_group" "tls_inet" {
  name        = "allow_tls"
  description = "Allows all inbound and output TLS traffic"
  vpc_id      = aws_vpc.personal.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "ssh_http_me" {
  name        = "allow_me_ssh_http"
  description = "Allows me to connect via raw HTTP and SSH"
  vpc_id      = aws_vpc.personal.id

  ingress {
    description = "SSH From Me"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  ingress {
    description = "HTTP From Me"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  tags = {
    Name = "allow_me_ssh_http"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allows all inbound and output HTTP traffic"
  vpc_id      = aws_vpc.personal.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}
