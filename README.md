# InfraPro

Terraform + Ansible + Jenkins project for AWS.

## Structure

- step1-three-servers: Terraform provisions 3 EC2 instances with VPC, subnet, security group, and key pair.
- step2-ansible-userdata: Same infrastructure, plus Ansible installed on the control node via user data. Dynamic inventory built from managed node IPs using Terraform templatefile.

## Requirements

- AWS account with IAM role or user having EC2, VPC permissions
- Terraform >= 1.5
- Jenkins with Pipeline plugin (for automated runs)

## Usage

Manual: `cd step2-ansible-userdata && terraform init && terraform apply`

Jenkins: parameterized pipeline drives terraform init, plan, apply, destroy.
