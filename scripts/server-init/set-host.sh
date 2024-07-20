#!/bin/bash

# master host와 hostname을 변경하는 스크립트
# argument: [hostname] [master private ip] [cluster1 private ip] [cluster2 private ip]
# 사용 예시: ./set-host.sh master 172.31.1.1 172.31.1.2 172.31.1.3

if [ -n "$1" ];then
  echo -e "\n=== hostname 등록"
  sudo hostnamectl set-hostname $1
  echo hostname=`hostname`
fi

# 모든 Arguement 대입
PRIVATE_IPS=$*
# 첫번째 Argument를 제외한 Argument
PRIVATE_IPS=${PRIVATE_IPS//$1/}

cnt=0
for PRIVATE_IP in $PRIVATE_IPS; do
    if [ $cnt -eq 0 ];then
        CLUSTER_NAME="master"
    else
        CLUSTER_NAME="cluster${cnt}"
    fi

    EXIST_CLUSTER_NAME=$(sudo cat /etc/hosts | grep ${CLUSTER_NAME})
    echo "CLUSTER_NAME=$CLUSTER_NAME, EXIST_CLUSTER_NAME=$EXIST_CLUSTER_NAME"
    if [ -n "${PRIVATE_IP}" -a -z "${EXIST_CLUSTER_NAME}" ];then
      echo -e "=== ${CLUSTER_NAME} host 등록==="
      sudo bash -c "echo '${PRIVATE_IP} ${CLUSTER_NAME}' >> /etc/hosts"
      echo $(sudo cat /etc/hosts | grep ${CLUSTER_NAME})
    fi
    cnt=$((cnt+1))
done