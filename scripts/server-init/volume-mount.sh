#!/bin/bash

# AWS EC2 추가 볼륨 자동 마운트 스크립트
# 마운트된 드라이브는 /home/ubuntu/data 에 연결됨

MOUNT_YN=$(df -hT | grep /home/ubuntu/data)
if [ -z "$MOUNT_YN" ];then
    echo -e "\n=== 추가 볼륨 포멧 ==="
    TARGET='nvme1n1'
    ERROR_MESSAGE=$(sudo mkfs -t ext4 /dev/${TARGET} 2>&1 | grep apparently)
    if [ -n "$ERROR_MESSAGE" ];then
        EXCEPT=`echo ${ERROR_MESSAGE:0:13} | sed 's/\/dev\///g'`
        TARGET=`lsblk | grep disk | grep -v ${EXCEPT} | cut -d ' ' -f 1`
        echo ERROR_MESSAGE=$ERROR_MESSAGE, EXCEPT=$EXCEPT, TARGET=$TARGET
        echo "sudo mkfs -t ext4 /dev/${TARGET}"
        sudo mkfs -t ext4 /dev/${TARGET}
    else
        echo TARGET=$TARGET
        echo "sudo mkfs -t ext4 /dev/${TARGET}"
        sudo mkfs -t ext4 /dev/${TARGET}
    fi

    if [ ! -d "/home/ubuntu/data" ];then
        echo -e "\n=== /home/ubuntu/data 디렉토리 생성 ==="
        sudo mkdir -p /home/ubuntu/data
        ls -alt /home/ubuntu | grep data
    fi
    echo -e "\n=== 추가 볼륨 마운트 ==="
    sudo mount /dev/${TARGET} /home/ubuntu/data
    df -hT | grep /home/ubuntu/data
    echo -e "\n=== /home/ubuntu/data 소유자/그룹 변경 ==="
    sudo chown -R 1000:1000 /home/ubuntu/data
    ls -alt /home/ubuntu | grep data
fi

CHECK_FSTAB=$(cat /etc/fstab | grep /home/ubuntu/data)
if [ -z "$CHECK_FSTAB" ];then
    echo -e "\n=== 영구 볼륨 설정 추가 ==="
    sudo bash -c "echo '/dev/${TARGET}    /home/ubuntu/data        ext4   defaults,noatime 0 1' >> /etc/fstab"
    cat /etc/fstab | grep /home/ubuntu/data
fi

#if [ ! -h "/home/ubuntu/data" ];then
#    echo -e "\n=== 하드 링크 연결 ==="
#    ln -s /dev/data /home/ubuntu/data
#    ls ~/data -alt
#fi

echo -e "\n=== 마운트 연결확인 ==="
sudo blkid | grep -v "squashfs"

echo -e "\n=== Docker Mount 디렉토리 생성 ==="
bash -c "~/scripts/make-dirs.sh"