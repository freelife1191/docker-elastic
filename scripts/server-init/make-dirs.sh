#!/bin/bash

# ELK 스택에 필요한 디렉토리 자동 생성 스크립트

HOME_DIR=$(echo ~)
DATA_DIR=${HOME_DIR}/data
LOG_DIR=${HOME_DIR}/log
echo HOME_DIR=$HOME_DIR, DATA_DIR=$DATA_DIR, LOG_DIR=$LOG_DIR
DIRS="elasticsearch kibana filebeat metricbeat packetbeat auditbeat logstash fluntd fluntbit"
for DIR in $DIRS; do
    if [ ! -d "$DATA_DIR/$DIR" ]; then
        echo "make -p $DATA_DIR/$DIR"
        mkdir -p "$DATA_DIR/$DIR"
    fi
    if [ ! -d "$LOG_DIR/$DIR" ]; then
        echo "make -p $LOG_DIR/$DIR"
        mkdir -p "$LOG_DIR/$DIR"
    fi
done
echo -e "\n=== $DATA_DIR 디렉토리 생성 확인 ==="
echo $(ls ~/data)
echo -e "\n=== $LOG_DIR 디렉토리 생성 확인 ==="
echo $(ls ~/log)