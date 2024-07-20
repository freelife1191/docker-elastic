#!/bin/bash

# 사전 실행 스크립트
bash /home/ubuntu/docker-elastic/scripts/preload.sh

# 기본 환경 변수 가져오기
HOME='/home/ubuntu/docker-elastic'
ENV_TEMPLATE="${HOME}/env-template.sh"
ENV="${HOME}/env.sh"
source ${ENV}

PROFILE=${PROFILE}
echo "PROFILE=${PROFILE}"

if [ -z "${PROFILE}" ];then
   echo ">> Entering profile is required :: Inputable profile [dev, prod]"
   exit 1
fi

# env 파일이 없으면 env 파일을 생성한다
# docker-elastic 스크립트들은 모두 env.sh 파일로부터 환경변수를 받아온다
if [ ! -e "${ENV}" ];then
    cp ${ENV_TEMPLATE} ${ENV}
    # GET IP 스크립트 추가
    bash -c "echo export alias getip=\'bash -c ~/docker-elastic/scripts/service-init/get-ip.sh\' >> ~/.zshrc"
fi

if [ ! -e "${ENV}" ];then
    echo "The 'env.sh' file was not created."
    echo "The 'env.sh' file is a file that must be created."
    exit 1
fi

# .zshrc에 env 정보 등록
#ENVIRONMENTS="PROFILE ELASTIC_VERSION ELASTICSEARCH_JVM_MEMORY ELASTICSEARCH_USERNAME ELASTICSEARCH_PASSWORD ELASTICSEARCH_HOST KIBANA_HOST INITIAL_MASTER_NODES AWS_ECR_PRIVATE_DOMAIN"
#for ENVIRONMENT in $ENVIRONMENTS; do
#    EXIST_ENVIRONMENT=$(cat ~/.zshrc | grep ${ENVIRONMENT})
#    if [ -z "${EXIST_ENVIRONMENT}" ];then
#        bash -c "echo export ${ENVIRONMENT}=\'$(eval echo \$${ENVIRONMENT})\' >> ~/.zshrc"
#    fi
#done

# timezone 설정
# https://www.lesstif.com/lpt/ubuntu-linux-timezone-setting-61899162.html
## timezonectl 사용 한국으로 설정
sudo timedatectl set-timezone 'Asia/Seoul'
## tzdata 설치
sudo apt install tzdata -y
## tzdata 를 ln 으로 링크 symbolic link
sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

#./sourceZshrc.sh

#for ENVIRONMENT in $ENVIRONMENTS; do
#    echo $(sudo cat ~/.zshrc | grep ${ENVIRONMENT})
#done