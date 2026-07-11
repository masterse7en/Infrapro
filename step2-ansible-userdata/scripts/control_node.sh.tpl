#!/bin/bash
set -e

# 1. Install Ansible
apt-get update -y
apt-get install -y software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible

# 2. Place the private key so ubuntu user can SSH into managed nodes
mkdir -p /home/ubuntu/.ssh
cat > /home/ubuntu/.ssh/id_rsa <<'PRIVATEKEY'
${private_key}
PRIVATEKEY
chmod 600 /home/ubuntu/.ssh/id_rsa
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa

# 3. Ansible project directory
mkdir -p /home/ubuntu/ansible

# 4. Inventory built from Terraform-provided private IPs
cat > /home/ubuntu/ansible/inventory.ini <<'INVENTORY'
[managed]
%{ for ip in managed_ips ~}
${ip}
%{ endfor ~}

[managed:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/ubuntu/.ssh/id_rsa
INVENTORY

# 5. Ansible config
cat > /home/ubuntu/ansible/ansible.cfg <<'CFG'
[defaults]
inventory = /home/ubuntu/ansible/inventory.ini
host_key_checking = False
CFG

chown -R ubuntu:ubuntu /home/ubuntu/ansible

echo "Control node setup complete" > /home/ubuntu/SETUP_DONE
chown ubuntu:ubuntu /home/ubuntu/SETUP_DONE

