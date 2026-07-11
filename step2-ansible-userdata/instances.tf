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

# Managed nodes created first, since control node user data needs their IPs
resource "aws_instance" "managed" {
  count                  = var.managed_node_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.servers.id]
  key_name               = aws_key_pair.this.key_name

  user_data = file("${path.module}/scripts/managed_node.sh")

  tags = {
    Name = "${var.project_name}-managed-node-${count.index + 1}"
    Role = "managed"
  }
}

resource "aws_instance" "control" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.servers.id]
  key_name               = aws_key_pair.this.key_name

  user_data = templatefile("${path.module}/scripts/control_node.sh.tpl", {
    private_key = tls_private_key.this.private_key_pem
    managed_ips = aws_instance.managed[*].private_ip
  })

  tags = {
    Name = "${var.project_name}-control-node"
    Role = "control"
  }
}
