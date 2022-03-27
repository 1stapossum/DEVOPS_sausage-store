#!/bin/bash
set +e
#cat > .env <<EOF
#SPRING_DATASOURCE_URL=${PSQL_HOST}
#SPRING_DATASOURCE_USERNAME=${PSQL_USER}
#SPRING_DATASOURCE_PASSWORD=${PSQL_DB_PASSWORD}
#SPRING_DATA_MONGODB_URI=${MONGO_URI_WHOLE}
#EOF

docker network create -d bridge sausage_network || true
docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
docker pull ${CI_REGISTRY_IMAGE}/sausage-frontend:latest
#docker pull ${CI_REGISTRY}/sausage-store/sausage-backend:latest
docker stop sausage-frontend || true
docker rm sausage-frontend || true
set -e
#docker run -d --name sausage-bacfrontend --network=sausage_network --pull always --restart always --env-file .env ${CI_REGISTRY_IMAGE}/sausage-frontend:latest
docker run -d --name sausage-frontend --network=sausage_network --pull always --restart always  ${CI_REGISTRY_IMAGE}/sausage-frontend:latest

    #--pull always