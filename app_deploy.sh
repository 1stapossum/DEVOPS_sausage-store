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
docker rmi  backend-report true

docker stop vault || true
docker rm vault || true
docker rmi vault ||true

docker-compose -d up


#cat <<EOF | docker exec -i vault ash
#  sleep 5;
#  vault login myroot
#  vault kv put secret/sausage-store spring.datasource.password="PSQL_DB_PASSWORD" spring.datasource.username="PSQL_USER" spring.data.mongodb.uri="MONGO_URI_WHOLE"
#EOF

cat > ihatevault.sh << EOFF
#!/usr/bin/bash
cat << EOF | docker exec -i vault ash
  sleep 5;
  vault login ${VAULT_TOKEN}
  vault kv put secret/sausage-store spring.datasource.username=${PSQL_USER} \
  spring.datasource.password=${PSQL_DB_PASSWORD} \
  spring.data.mongodb.uri=${MONGO_URI_WHOLE}
EOF
EOFF

chmod +x ihatevault.sh
sleep 15
bash ihatevault.sh
sleep 5
rm -f ihatevault.sh

