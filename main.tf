# Creamos una instancia EC2
resource "aws_instance" "instancia_ejemplo_01" {
  ami           = "ami-00874d747dde814fa"
  instance_type = "t2.small"
  key_name      = "vockey"
  tags = {
    Name = "instancia_ejemplo_01"
  }
}