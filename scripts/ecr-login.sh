#!/bin/bash

## ECR 로그인

#AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
#AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

# 사전 실행 스크립트
bash /home/ubuntu/docker-elastic/scripts/preload.sh

# 기본 환경 변수 가져오기
HOME='/home/ubuntu/docker-elastic'
ENV="${HOME}/env.sh"
source ${ENV}

#if [ -z "${AWS_ECR_PRIVATE_DOMAIN}" ];then
#   echo ">> source ~/.zshrc"
#   ./sourceZshrc.sh
#   AWS_ECR_PRIVATE_DOMAIN=${AWS_ECR_PRIVATE_DOMAIN}
#fi
if [ -z "${AWS_ECR_PRIVATE_DOMAIN}" ];then
   echo ">> Is Required AWS_ECR_PRIVATE_DOMAIN :: excute init.sh"
   exit 1
fi
# EC2 Role 연결로 ECR 권한 부여(보안강화)
#if [ -z "${AWS_ACCESS_KEY_ID}" -o -z "${AWS_SECRET_ACCESS_KEY}" ];then
#    echo ">> source ~/.zshrc"
#    ./sourceZshrc.sh
#fi
#if [ "$PROFILE" != "PROD" ];then
#    if [ -z "${AWS_ACCESS_KEY_ID}" -o -z "${AWS_SECRET_ACCESS_KEY}" ];then
#        echo ">> Is required AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY"
#        exit 1
#    fi
#fi

AWSCLI_INSTALL=$(aws --version 2>&1 | grep aws-cli | wc -l)

# 만약 AWS CLI2가 설치되지 않았다면
if [ "$AWSCLI_INSTALL" -ne 1 ];then
  echo ">> AWS CLI2 설치" #| tee -a deploy.log
  # Ubuntu AWS CLI2 설치
  sudo apt update && \
  sudo apt-get install unzip -y && \
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${HOME}/scripts/awscliv2.zip" && \
  sudo unzip ${HOME}/scripts/awscliv2.zip && \
  sudo ${HOME}/scripts/aws/install
  sudo rm ${HOME}/scripts/awscliv2.zip
  sudo rm -rf ${HOME}/scripts/aws

  # MacOS AWS CLI2 설치
  #curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "${HOME}/AWSCLIV2.pkg"
  #sudo installer -pkg ${HOME}/AWSCLIV2.pkg -target /
  #rm ${HOME}/AWSCLIV2.pkg
fi

# EC2 Role 연결로 ECR 권한 부여(보안강화)
#if [ "$PROFILE" != "PROD" ];then
#   AWS_CREDENTIALS="$(echo ~)/.aws/credentials"
#   # credentials 파일이 없으면 config 셋팅
#   if [ ! -e $AWS_CREDENTIALS ]; then
#     echo ">> AWS Credentials 설정"
#     aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}" && \
#     aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}" && \
#     aws configure set region ap-northeast-2 && \
#     aws configure set output json
#   else
#       if [ -z $AWS_CREDENTIALS_AWS_ACCESS_KEY_ID -o -z $AWS_CREDENTIALS_AWS_SECRET_ACCESS_KEY ]; then
#           echo ">> AWS Credentials 설정"
#           aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}" && \
#           aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}" && \
#           aws configure set region ap-northeast-2 && \
#           aws configure set output json
#       fi
#   fi
#fi

echo ">> aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${AWS_ECR_PRIVATE_DOMAIN}" #| tee -a deploy.log
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${AWS_ECR_PRIVATE_DOMAIN} #| tee -a deploy.log