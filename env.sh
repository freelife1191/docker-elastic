#!/bin/bash
# Copy this file and set up the env file on the server.
export HOME='/home/ubuntu/docker-elastic'
export PROFILE='dev' # dev, prod
export UID="$(id -u)"
export ELASTIC_VERSION='7.10.2'
export ELASTICSEARCH_USERNAME='elastic'
export ELASTICSEARCH_PASSWORD='elastic'
export SWARMPIT_ADMIN_USERNAME='admin'
export SWARMPIT_ADMIN_PASSWORD='admin'
export ELASTICSEARCH_HOST='master'
export KIBANA_HOST='master'
export CLUSTER1_HOST='cluster1'
export CLUSTER2_HOST='cluster2'
export INITIAL_MASTER_NODES='master'
# AWS_ECR_PRIVATE_DOMAIN URL은 각자 사용하는 AWS 계정에 맞게 수정해야 된다
if [[ "${PROFILE}" == "prod" ]];then
    export ELASTICSEARCH_JVM_MEMORY='20g' # prod 20g
    export ELASTICSEARCH_UPDATE_DELAY='120s' # prod 120s
    export AWS_ECR_PRIVATE_DOMAIN='2XXXXXXXXXXX.dkr.ecr.ap-northeast-2.amazonaws.com'
else
    export ELASTICSEARCH_JVM_MEMORY='1g' # prod 20g
    export ELASTICSEARCH_UPDATE_DELAY='60s' # prod 120s
    export AWS_ECR_PRIVATE_DOMAIN='3XXXXXXXXXXX.dkr.ecr.ap-northeast-2.amazonaws.com'
fi