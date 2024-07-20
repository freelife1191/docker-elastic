#!/bin/bash

# 사전 실행 스크립트
# bash /home/ubuntu/docker-elastic/scripts/preload.sh

# docker swarm init 및 join-token 발급
# 발급된 join-token을 각 worker node 에서 실행시켜서 join 시켜줘야됨


if [ "$PROFILE" != "prod" ];then
    PUBLIC_IP=$(curl -s 'http://169.254.169.254/latest/meta-data/public-ipv4')
fi
PRIVATE_IP=$(curl -s 'http://169.254.169.254/latest/meta-data/local-ipv4')

SWARM_MODE=$(docker info | grep Swarm | sed -e 's/^ *//g' -e 's/ *$//g')
if [ "${SWARM_MODE}" == "Swarm: inactive" ];then
    # 도커 스웜 매니저 서버 기준으로 클러스터를 시작하도록 설정
    docker swarm init --advertise-addr ${PRIVATE_IP} --listen-addr ${PRIVATE_IP}:2377
else
    # 다중 워커 노드 추가 조인 키 조회
    docker swarm join-token worker
    # 다중 매니저 노드 추가 조인 키 조회
    #docker swarm join-token manager
fi