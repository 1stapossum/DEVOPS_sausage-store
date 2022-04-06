#!/bin/bash
set +e
docker network create -d bridge sausage_network || true
docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}

docker pull ${CI_REGISTRY_IMAGE}/sausage-backend:latest
docker pull ${CI_REGISTRY_IMAGE}/sausage-frontend:latest
docker pull ${CI_REGISTRY_IMAGE}/backend-report:latest

docker stop sausage-frontend || true
docker rm sausage-frontend || true
docker rmi sausage-frontend || true

docker stop sausage-backend || true
docker rm sausage-backend || true
docker rmi sausage-backend || true

docker stop backend-report || true
docker rm backend-report || true
docker rmi  || backend-report true


docker stop vault || true
docker rm vault || true
docker rmi vault || true

#docker create --cap-add=IPC_LOCK --name vault -p 8200:8200 -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' -e 'VAULT_SERVER=http://127.0.0.1:8200' -e 'VAULT_ADDR=http://127.0.0.1:8200' vault
##
docker run -d --cap-add=IPC_LOCK --name vault -p 8200:8200 -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' -e 'VAULT_SERVER=http://127.0.0.1:8200' -e 'VAULT_ADDR=http://127.0.0.1:8200' vault

#cat >  vault_params <<\eof
cat <<EOF | docker exec -i vault ash
  sleep 10;
  vault login myroot
  vault secrets enable -path=secret kv
  vault kv put secret/sausage-store spring.datasource.password=${PSQL_DB_PASSWORD} spring.datasource.username=${PSQL_USER} spring.data.mongodb.uri=${MONGO_URI_WHOLE}
EOF


docker-compose -d up