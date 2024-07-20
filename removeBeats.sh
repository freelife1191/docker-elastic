#!/bin/bash

# docker stack rm auditbeat
docker stack rm filebeat
docker stack rm metricbeat
docker stack rm packetbeat
docker stack rm heartbeat