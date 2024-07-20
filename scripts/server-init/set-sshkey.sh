#!/bin/bash

# Bitbucket 용 ed25519 SSH KEY 발급

SSH_KEY_FILE="/home/ubuntu/.ssh/id_ed25519.pub"
if [ ! -e "${SSH_KEY_FILE}" ];then
    echo "sh-keygen -t ed25519 -b 256"
    ssh-keygen -t ed25519 -b 256
fi
echo -e "\n>> cat ~/.ssh/id_ed25519.pub"
cat ~/.ssh/id_ed25519.pub