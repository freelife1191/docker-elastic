#!/bin/bash

# 사전 실행 스크립트
bash /home/ubuntu/docker-elastic/scripts/preload.sh

# 기본 환경 변수 가져오기
HOME='/home/ubuntu/docker-elastic'
ENV="${HOME}/env.sh"
source ${ENV}

#export SWARMPIT_ADMIN_USERNAME=${1:-admin}
#export SWARMPIT_ADMIN_PASSWORD=${2:-'tourvis!@'}

# https://swarmpit.io/
# https://github.com/swarmpit/swarmpit
# default install docker
# docker run -it --rm \
#   --name swarmpit-installer \
#   --volume /var/run/docker.sock:/var/run/docker.sock \
# swarmpit/install:1.9
#docker run -it --rm \
#  --name swarmpit-installer \
#  --volume /var/run/docker.sock:/var/run/docker.sock \
#swarmpit/install:1.9

# https://velog.io/@hanif/Deploy-Github-Action%EA%B3%BC-Docker-Swarm%EC%9C%BC%EB%A1%9C-%EB%B0%B0%ED%8F%AC%ED%95%98%EA%B8%B0
# https://github.com/swarmpit/swarmpit/issues/310
# https://github.com/swarmpit/agent
# https://github.com/swarmpit/installer
# docker run -it --rm \
#   --name swarmpit-installer \
#   --volume /var/run/docker.sock:/var/run/docker.sock \
#   -e INTERACTIVE=0 \
#   -e STACK_NAME=swarmpit \
#   -e APP_PORT=888 \
#   -e ADMIN_USERNAME=${SWARMPIT_ADMIN_USERNAME} \
#   -e ADMIN_PASSWORD=${SWARMPIT_ADMIN_PASSWORD} \
#   -e HEALTH_CHECK_ENDPOINT=http://swarmpit-app:8080/version \
#   -e EVENT_ENDPOINT=http://swarmpit-app:8080/events \
#   -e TZ=Asia/Seoul \
#   swarmpit/install:edge

# docker compose로 배포
docker stack deploy --compose-file swarmpit-docker-compose.yml swarmpit