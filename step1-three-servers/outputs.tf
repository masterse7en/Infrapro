output "control_node_public_ip" {
  value = aws_instance.control.public_ip
}

output "control_node_private_ip" {
  value = aws_instance.control.private_ip
}

output "managed_nodes_public_ips" {
  value = aws_instance.managed[*].public_ip
}

output "managed_nodes_private_ips" {
  value = aws_instance.managed[*].private_ip
}

output "ssh_command_control" {
  value = "ssh -i ${var.project_name}-key.pem ubuntu@${aws_instance.control.public_ip}"
}
