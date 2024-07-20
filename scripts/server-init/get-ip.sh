#!/bin/bash

# 인스턴스 IP 정보를 쉽게 조회하기 위한 스크립트

CHECK_OS=$(uname -s)
NET_TOOLS=$(dpkg -l | grep net-tools | awk '{print $2}')
if [ -z "${NET_TOOLS}" ];then
  sudo apt install net-tools -y
fi

case "${CHECK_OS}" in
	Linux*)
      OS=${CHECK_OS}
      REGION=$(curl -s 'http://169.254.169.254/latest/meta-data/placement/region')
      if [ "$PROFILE" != "prod" ];then
        PUBLIC_IP=$(curl -s 'http://169.254.169.254/latest/meta-data/public-ipv4')
      fi
      PRIVATE_IP=$(curl -s 'http://169.254.169.254/latest/meta-data/local-ipv4')
      ;;
    *)
      OS=${CHECK_OS}
      PUBLIC_IP=$(curl -s ifconfig.me)
      PRIVATE_IP=$(hostname -i)
      #PRIVATE_IP=$(ifconfig -a | grep "inet 172*" | grep "netmask 255.255.240.0" | awk '{print $2}')
esac

echo "OS=$OS, REGION=$REGION, PUBLIC_IP=$PUBLIC_IP, PRIVATE_IP=$PRIVATE_IP"