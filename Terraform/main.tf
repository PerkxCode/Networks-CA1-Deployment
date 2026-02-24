resource "aws_key_pair" "deployer_key" {
  key_name   = "b9is121-key"
  public_key = file("~/.ssh/b9is121_key.pub")
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c38b837cd80f13bb" 
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer_key.key_name

  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  tags = {
    Name = "B9IS121-Docker-Server"
  }
}