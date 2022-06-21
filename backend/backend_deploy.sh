#!/bin/bash
set +e
#cat > .env <<EOF
#SPRING_DATASOURCE_URL=${PSQL_HOST}
#SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
#SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
#SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
#EOF

docker network create -d bridge sausage_network || true
docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
docker pull ${CI_REGISTRY_IMAGE}/sausage-backend:${VERSION}
#docker pull ${CI_REGISTRY}/sausage-store/sausage-backend:${VERSION}
docker stop sausage-backend || true
docker rm sausage-backend || true
set -e
docker run -d --name sausage-backend --network=sausage_network --pull always --restart always --env-file .env ${CI_REGISTRY_IMAGE}/sausage-backend:${VERSION}

    #--pull always !!!!!