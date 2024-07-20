#!/bin/bash

# Crontab에 등록해서 주기적으로 실행

#* * * * * sudo -u ubuntu /home/ubuntu/docker-elastic/scripts/cron-start.sh 2>&1 | tee /home/ubuntu/docker-elastic/crontab.log
# 1시간마다 cron-start.sh
#0 */1 * * * sudo -u ubuntu /home/ubuntu/docker-elastic/scripts/cron-start.sh 2>&1 | tee /home/ubuntu/docker-elastic/crontab.log
# 1분마다 cron-start.sh
#*/1 * * * * sudo -u ubuntu /home/ubuntu/docker-elastic/scripts/cron-start.sh 2>&1 | tee /home/ubuntu/docker-elastic/crontab.log

# 사전 실행 스크립트
bash /home/ubuntu/docker-elastic/scripts/preload.sh

# 기본 환경 변수 가져오기
HOME='/home/ubuntu/docker-elastic'
ENV="${HOME}/env.sh"
source ${ENV}

# ECR 로그인
echo "[$(date '+%Y-%m-%d %H:%M:%S')][STEP-0] ecr-login cron execute" | tee ${HOME}/cron.log
#sudo -u ubuntu /home/ubuntu/docker-elastic/scripts/ecr-login.sh 2>&1 | tee -a ${HOME}/cron.log

bash ${HOME}/scripts/ecr-login.sh 2>&1 | tee -a ${HOME}/cron.log

# Kibana ECR 이미지 Pull
echo "[$(date '+%Y-%m-%d %H:%M:%S')][STEP-1] docker pull ${AWS_ECR_PRIVATE_DOMAIN}/kibana:${ELASTIC_VERSION}" | tee -a ${HOME}/cron.log
docker pull ${AWS_ECR_PRIVATE_DOMAIN}/kibana:${ELASTIC_VERSION} 2>&1 | tee -a ${HOME}/cron.log

# Elasticsearch ECR 이미지 Pull
echo "[$(date '+%Y-%m-%d %H:%M:%S')][STEP-2] docker pull ${AWS_ECR_PRIVATE_DOMAIN}/elasticsearch:${ELASTIC_VERSION}" | tee -a ${HOME}/cron.log
docker pull ${AWS_ECR_PRIVATE_DOMAIN}/elasticsearch:${ELASTIC_VERSION} 2>&1 | tee -a ${HOME}/cron.log

# ELK 스크립트 최신 업데이트
echo "[$(date '+%Y-%m-%d %H:%M:%S')][STEP-3] git -C ${HOME} pull" | tee -a ${HOME}/cron.log
git -C ${HOME} pull 2>&1 | tee -a ${HOME}/cron.log