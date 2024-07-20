#!/bin/bash

# 사전 실행 스크립트
bash /home/ubuntu/docker-elastic/scripts/preload.sh

# 기본 환경 변수 가져오기
HOME='/home/ubuntu/docker-elastic'
ENV="${HOME}/env.sh"
source ${ENV}

## ECR 이미지 빌드 공통
VERSION=${ELASTIC_VERSION}
IMAGE_NAME=${AWS_ECR_PRIVATE_DOMAIN}/${APP_NAME}:${VERSION}

bash ${HOME}/scripts/ecr-login.sh

echo ">> docker build ${HOME}/elk/${APP_NAME} -t ${APP_NAME}:${VERSION} --build-arg ELASTIC_VERSION=${ELASTIC_VERSION}"
# docker build ../. -t "${IMAGE_NAME}" --no-cache --progress=plain --pull=true --build-arg ELASTIC_VERSION=${ELASTIC_VERSION}
docker build  ${HOME}/elk/${APP_NAME} -t "${APP_NAME}:${VERSION}" --build-arg ELASTIC_VERSION=${ELASTIC_VERSION}

echo ">> docker tag ${APP_NAME}:${VERSION} ${IMAGE_NAME}"
docker tag ${APP_NAME}:${VERSION} ${IMAGE_NAME}

echo ">> docker push ${IMAGE_NAME}"
docker push ${IMAGE_NAME}