#!/bin/bash
apt-get update -y
apt-get install -y python3
echo "Managed node ready" > /home/ubuntu/SETUP_DONE
chown ubuntu:ubuntu /home/ubuntu/SETUP_DONE

