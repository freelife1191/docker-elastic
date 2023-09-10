#!/bin/bash

export ELASTIC_VERSION=7.10.2
export ELASTICSEARCH_USERNAME=elastic
export ELASTICSEARCH_PASSWORD=tourvis
export ELASTICSEARCH_HOST=es-master
export INITIAL_MASTER_NODES=es-master

./buildElastic.sh

docker network create --driver overlay --attachable elastic
docker stack deploy --compose-file docker-compose.yml elastic
