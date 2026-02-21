#key-pair
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

#vpc and security group
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_sg"
  description = "his will add a security group"
  vpc_id      = aws_default_vpc.default.id  #interpolation

  #inbound rules
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
  }

  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
  }




  #outbound rules

  egress{
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  tags = {
    Name = "allow_sg"
  }

}

# ec2 instance

resource "aws_instance" "my_instance" {
  key_name =  aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.allow_tls.name]
  instance_type = "t3.micro"
  ami = "ami-0b6c6ebed2801a5cb"

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "My_first_instance"
  }
}