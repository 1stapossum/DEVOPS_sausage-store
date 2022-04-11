#!/bin/bash
set +e
docker network create -d bridge sausage_network || true
docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}

sleep 5
docker-compose pull
docker-compose up -d
docker-compose up -d --scale backend=2

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

chmod +x ihatevault.sh
sleep 15
bash ihatevault.sh

