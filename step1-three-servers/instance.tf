data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "control" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.servers.id]
  key_name               = aws_key_pair.this.key_name

  tags = {
    Name = "${var.project_name}-control-node"
    Role = "control"
  }
}

resource "aws_instance" "managed" {
  count                  = var.managed_node_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.servers.id]
  key_name               = aws_key_pair.this.key_name

  tags = {
    Name = "${var.project_name}-managed-node-${count.index + 1}"
    Role = "managed"
  }
}
