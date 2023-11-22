data "aws_ami" "bootcamp-ami" { # déclaration de la source de données de type aws_ami (ami aws)
  most_recent = true            # demande à avoir l'image la plus recente disponible
  owners      = ["amazon"]      # lorsque le proriétaire de l'image s'appele amazon
  filter {                      # on ajoute un filtre  
    name   = "name"             # on veut filtrer l'image lorsque le nom à comme par amzn2-ami-hvm- , * pour n'importe quoi , et se termine par -x86_64-gp2
    values = ["amzn2-ami-hvm-*"]
  }
}

## Création de serveurs bootcamp pour le sous-réseau d'application A
resource "aws_security_group" "sg_bootcamp" {
  name   = "sg_bootcamp"
  vpc_id = aws_vpc.bootcamp_vpc.id
  tags = {
    Name        = "sg-bootcamp"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "allow_all" {
  type              = "ingress"
  cidr_blocks       = ["10.1.0.0/24"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_bootcamp.id
}

resource "aws_security_group_rule" "outbound_allow_all" {
  type = "egress"

  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_bootcamp.id
}

## Création du serveur bootcamp pour le sous-réseau d'application A
resource "aws_instance" "bootcamp_a" {
  ami                    = data.aws_ami.bootcamp-ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.app_subnet_a.id
  vpc_security_group_ids = ["${aws_security_group.sg_bootcamp.id}"]
  #key_name               = "${aws_key_pair.myec2key.key_name}"
  user_data = file("install_wordpress.sh")
  tags = {
    Name        = "bootcamp-a"
    Environment = var.environment
  }
}

## Fin 

## Création de serveur bootcamp pour le sous-réseau d'application B

resource "aws_instance" "bootcamp_b" {
  ami                    = data.aws_ami.bootcamp-ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.app_subnet_b.id
  vpc_security_group_ids = ["${aws_security_group.sg_bootcamp.id}"]
  #key_name               = "${aws_key_pair.myec2key.key_name}"
  user_data = file("install_wordpress.sh")
  tags = {
    Name        = "bootcamp-b"
    Environment = var.environment
  }

}
## Fin
