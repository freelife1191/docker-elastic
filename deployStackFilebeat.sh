#!/bin/bash

# Filebeat 배포 스크립트

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
    docker network create --driver overlay --attachable $ELASTICSEARCH_USERNAME
fi

docker stack deploy --compose-file filebeat-docker-compose.yml filebeat


#curl -XGET -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} ${ELASTICSEARCH_HOST}':9200/_cat/indices?v&pretty'