#!/bin/bash

# 사전 실행 스크립트
bash /home/ubuntu/docker-elastic/scripts/preload.sh

# 기본 환경 변수 가져오기
HOME='/home/ubuntu/docker-elastic'
ENV="${HOME}/env.sh"
source ${ENV}

# kibana ecr 이미지 빌드 스크립트
export APP_NAME='kibana'

bash ${HOME}/scripts/buildCommon.sh