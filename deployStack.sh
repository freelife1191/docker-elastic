#!/bin/bash

# ELK Stack 배포 스크립트

# 사전 실행 스크립트
bash /home/ubuntu/docker-elastic/scripts/preload.sh

# 기본 환경 변수 가져오기
HOME='/home/ubuntu/docker-elastic'
ENV="${HOME}/env.sh"
source ${ENV}

#EXIST_NETWORK=$(docker network inspect msa-network -f "{{json .Id}}")
EXIST_NETWORK=$(docker network ls | grep $ELASTICSEARCH_USERNAME)
# 생성된 network가 없으면
if [ -z "$EXIST_NETWORK" ]; then
    echo ">> docker network create --driver overlay --attachable ${ELASTICSEARCH_USERNAME}"
    docker network create --driver overlay --attachable ${ELASTICSEARCH_USERNAME}
fi

echo ">> docker stack deploy --compose-file docker-compose.yml elastic"
docker stack deploy --with-registry-auth --compose-file docker-compose."${PROFILE}".yml elastic

# elasticsearch 노드 전체 aws login 인증 정보 전파
#echo ">> docker service update -d -q --with-registry-auth elastic_elasticsearch"
#docker service update -d -q --with-registry-auth elastic_elasticsearch
#echo ">> docker service update -d -q --with-registry-auth elastic_kibana"
#docker service update -d -q --with-registry-auth elastic_kibana