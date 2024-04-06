module "ec2-instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = data.aws_ami.centos8.id
  name                   = "eksctl-workstation"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_eksctl.id]
  subnet_id              = "subnet-01c1c823852d19a68"
  user_data              = file("workstation.sh")

  tags = {
    Terraform   = "true"
    Envieonment = "dev"
  }
}

resource "aws_security_group" "allow_eksctl" {
  name        = "allow_eksctl"
  description = "created for eksctl"

  ingress {
    description = "all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # egress is always same for sg, so we are keeping it here as static
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eksctl-workstation-sg"
  }
}


data "aws_ami" "centos8" {
  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["Centos-8-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}