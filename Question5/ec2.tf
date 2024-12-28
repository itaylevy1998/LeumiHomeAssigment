data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}



resource "aws_instance" "test-ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = local.instance_type
  vpc_security_group_ids = [aws_security_group.test-ec2-sg.id]
  subnet_id              = aws_subnet.public-subnet.id
  key_name               = "jenkins"

  tags = {
    Name = "test-ec2"
  }
  user_data = file("./installApache.sh")
}

resource "aws_eip" "test-ec2-eip" {
  domain   = "vpc"
  instance = aws_instance.test-ec2.id
  tags = {
    Name = "q5-eip"
  }
}