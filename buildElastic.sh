ELASTIC_VERSION=${ELASTIC_VERSION:-7.10.2}
VERSION='latest'

APP_NAME='elasticsearch'
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-''}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-''}
AWS_ECR_PRIVATE_DOMAIN='339927058960.dkr.ecr.ap-northeast-2.amazonaws.com'
IMAGE_NAME=${AWS_ECR_PRIVATE_DOMAIN}/${APP_NAME}:${VERSION}

AWSCLI_INSTALL=$(aws --version | grep aws-cli | wc -l)

# 만약 AWS CLI2가 설치되지 않았다면
if [ "$AWSCLI_INSTALL" -ne 1 ];then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')][STEP-0] AWS CLI2 설치" #| tee -a deploy.log
  # Ubuntu AWS CLI2 설치
  sudo apt update && \
  sudo apt-get install unzip -y && \
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
  sudo unzip awscliv2.zip && \
  sudo ./aws/install
  rm awscliv2.zip

  # MacOS AWS CLI2 설치
  #curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  #sudo installer -pkg AWSCLIV2.pkg -target /
  #rm AWSCLIV2.pkg
fi

AWS_CREDENTIALS="$(echo ~)/.aws/credentials"

# credentials 파일이 없으면 config 셋팅
if [ ! -e $AWS_CREDENTIALS ]; then
  aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}" && \
  aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}" && \
  aws configure set region ap-northeast-2 && \
  aws configure set output json
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${AWS_ECR_PRIVATE_DOMAIN}" #| tee -a deploy.log
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${AWS_ECR_PRIVATE_DOMAIN} #| tee -a deploy.log

echo "[$(date '+%Y-%m-%d %H:%M:%S')] docker build --build-arg --build-arg ELASTIC_VERSION=${ELASTIC_VERSION}"
# docker build ../. -t "${IMAGE_NAME}" --no-cache --progress=plain --pull=true --build-arg ELASTIC_VERSION=${ELASTIC_VERSION}
docker build ./elk/elasticsearch -t "${APP_NAME}:${VERSION}" --build-arg ELASTIC_VERSION=${ELASTIC_VERSION}

docker tag ${APP_NAME}:${VERSION} ${IMAGE_NAME}

docker push ${IMAGE_NAME}