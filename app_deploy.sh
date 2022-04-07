#!/bin/bash
set +e
docker network create -d bridge sausage_network || true
docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}


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
docker rmi vault || true


docker pull ${CI_REGISTRY_IMAGE}/sausage-backend:latest
docker pull ${CI_REGISTRY_IMAGE}/sausage-frontend:latest
docker pull ${CI_REGISTRY_IMAGE}/backend-report:latest


sleep 5
docker-compose up -d


#cat <<EOF | docker exec -i vault ash
#  sleep 5;
#  vault login myroot
#  vault kv put secret/sausage-store spring.datasource.password="PSQL_DB_PASSWORD" spring.datasource.username="PSQL_USER" spring.data.mongodb.uri="MONGO_URI_WHOLE"
#EOF

cat > ihatevault.sh << EOFF
#!/usr/bin/bash
cat << EOF | docker exec -i vault ash
  sleep 10
  vault login ${VAULT_DEV_ROOT_TOKEN_ID}
  vault kv put secret/sausage-store spring.datasource.username=${SPRING_DATASOURCE_USERNAME} \
  spring.datasource.password=${SPRING_DATASOURCE_PASSWORD} \
  spring.data.mongodb.uri=${SPRING_DATA_MONGODB_URI}
EOF
EOFF

#docker exec -i vault ash
#sleep 10
#vault login ${VAULT_DEV_ROOT_TOKEN_ID}
#vault kv put secret/sausage-store spring.datasource.username=${SPRING_DATASOURCE_USERNAME} 
#vault kv put secret/spring.datasource.password=${SPRING_DATASOURCE_PASSWORD}  
#vault kv put secret/spring.data.mongodb.uri=${SPRING_DATA_MONGODB_URI}
#exit



chmod +x ihatevault.sh
sleep 15
bash ihatevault.sh

