#!/bin/bash

# ELK Stack 배포 스크립트

# 사전 실행 스크립트
bash /home/ubuntu/docker-elastic/scripts/preload.sh

# 기본 환경 변수 가져오기
HOME='/home/ubuntu/docker-elastic'
ENV="${HOME}/env.sh"
source ${ENV}

# 올바른 서비스 입력 확인
#SERVICE_NAME=$1
#SERVICE_LIST="swarm-listener proxy elasticsearch kibana apm-server"
#
#CHECK=1
#for SERVICE in ${SERVICE_LIST}
#do
#    [ "${SERVICE}" = "${SERVICE_NAME}" ] && CHECK=0 && break
#done
#
#if [ $CHECK -eq 1 ]; then
#    echo "\"${SERVICE_NAME}\" [${SERVICE_LIST}] Enter one of the services."
#    exit 1
#fi

#EXIST_NETWORK=$(docker network inspect msa-network -f "{{json .Id}}")
EXIST_NETWORK=$(docker network ls | grep $ELASTICSEARCH_USERNAME)
# 생성된 network가 없으면
if [ -z "$EXIST_NETWORK" ]; then
    echo ">> docker network create --driver overlay --attachable ${ELASTICSEARCH_USERNAME}"
    docker network create --driver overlay --attachable ${ELASTICSEARCH_USERNAME}
fi

#1- always: always re-deploy irrespective of any changes
#2- changed: only when if there are any changes in images
#3- never: never irrespective of images changes

echo ">> stack deploy --with-registry-auth --compose-file docker-compose."${PROFILE}".yml elastic"
docker stack deploy --with-registry-auth -c docker-compose."${PROFILE}".yml --resolve-image changed elastic