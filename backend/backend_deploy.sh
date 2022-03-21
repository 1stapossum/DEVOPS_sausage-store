#!/bin/bash
set +e
cat > .env <<EOF
SPRING_DATASOURCE_URL=${PSQL_HOST}
SPRING_DATASOURCE_USERNAME=${PSQL_USER}
SPRING_DATASOURCE_PASSWORD=${PSQL_DB_PASSWORD}
SPRING_DATA_MONGODB_URI=mongodb://antinitrino:${MONGO_PASSWORD}@rc1b-nczpq63snuc5a3z2.mdb.yandexcloud.net:27018/antinitrino?tls=true
EOF
#docker network create -d bridge sausage_network || true
docker pull ${$CI_REGISTRY}/sausage-store/sausage-backend:latest
docker stop backend || true
docker rm backend || true
set -e
docker run -d --name backend \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    ${$CI_REGISTRY}/sausage-store/sausage-backend:latest