#!/bin/zsh

# .zshrc 에 AWS KEY를 셋팅하는 스크립트
# arguments: [AWS_ACCESS_KEY_ID] [AWS_SECRET_ACCESS_KEY]
# 사용 예시: ./set-awskey.sh AAAAAAAAAAAAAAAAAAAA dddddddddddddddddddddddddddddddddddddddd

INPUT_AWS_ACCESS_KEY_ID=$1
INPUT_AWS_SECRET_ACCESS_KEY=$2
echo "INPUT AWS_ACCESS_KEY_ID=$INPUT_AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY=$INPUT_AWS_SECRET_ACCESS_KEY"

if [ -n "$INPUT_AWS_ACCESS_KEY_ID" -a -n "$INPUT_AWS_SECRET_ACCESS_KEY" ];then
    echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
    if [ -z "${AWS_ACCESS_KEY_ID}" -o -z "${AWS_SECRET_ACCESS_KEY}" ];then
        bash -c "echo export AWS_ACCESS_KEY_ID=\'${INPUT_AWS_ACCESS_KEY_ID}\' >> ~/.zshrc" \
        && bash -c "echo export AWS_SECRET_ACCESS_KEY=\'${INPUT_AWS_SECRET_ACCESS_KEY}\' >> ~/.zshrc"
        source ~/.zshrc
        echo "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"
        echo "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"
    fi
fi