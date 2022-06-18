#!/usr/bin/bash
cat << EOF | docker exec -i vault ash
  sleep 10
  vault login myroot
  vault kv put secret/sausage-store spring.datasource.username=student   spring.datasource.password=student123   spring.data.mongodb.uri=mongodb://antinitrino:Testusr1234@rc1c-ycrblochlggs1qv9.mdb.yandexcloud.net:27018/antinitrino?tls=true
EOF
