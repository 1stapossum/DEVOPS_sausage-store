#!/bin/bash
set -e
docker network create -d bridge sausage_network || true
docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}

#docker-compose pull
#docker-compose up -d
docker-compose pull backend-report
docker-compose up -d backend-report
docker-compose pull frontend
docker-compose up -d frontend
docker-compose pull vault
docker-compose up -d vault
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
#vault_status=$(docker inspect -f {{.State.Running}} $(docker ps  -q --filter="name=vault"))
#until [ "$vault_status" == "true" ]
#do
#    sleep 0.1;
#vault_status=$(docker inspect -f {{.State.Running}} $(docker ps  -q --filter="name=vault"))
#        echo $vault_status;
#done
sleep 15
bash ihatevault.sh
docker exec -d  sausage-frontend docker-gen -only-exposed -watch -notify "/etc/init.d/nginx reload" /app/proxytemplate /etc/nginx/nginx.conf

#BACKEND RUN CHECK
command1=$(docker ps -aq  --filter status=running --filter="name=green")
command2=$(docker ps -aq  --filter status=running --filter="name=blue")
#echo "$command1"
#echo "$command2"
if [[ -z $command1 ]] && [[ -z $command2 ]]; then
echo "BACK is DOWN"
docker-compose scale backend-blue=2
exit 0
else 
echo "BACK is UP"
fi


### BLUE/GREEN
CONTAINER_RUN_CHECK_ALL=$(docker container ls)				#All 
CONTAINER_RUN_CHECK_BLUE=$(docker ps  -q --filter="name=blue")	#BLUE
CONTAINER_RUN_CHECK_GREEN=$(docker ps  -q --filter="name=green")	#GREEN

if [[ $CONTAINER_RUN_CHECK_ALL == *"blue"* ]]; then
  echo "Blue backend runing"
  echo "Stoping green"
docker-compose stop backend-green
docker-compose rm -f backend-green 
docker-compose pull backend-green #budem schitat chto pull
  echo "Starting Green"
docker-compose up -d backend-green
command_green=$(docker inspect -f {{.State.Health.Status}} $(docker ps  -q --filter="name=green"))
until [ "$command_green" == "healthy" ] 
do
    sleep 1;
command_green=$(docker inspect -f {{.State.Health.Status}} $(docker ps  -q --filter="name=green"))
	echo "Green is $command_green";
done
docker-compose scale backend-green=2
  echo "Stoping blue!"
docker-compose stop backend-blue
docker-compose rm -f backend-blue

elif [[ $CONTAINER_RUN_CHECK_ALL == *"green"* ]]; then
  echo "Green backend runing"
  echo "Stoping blue"
docker-compose stop backend-blue
docker-compose rm -f backend-blue
docker-compose pull backend-blue #budem schitat chto pull
  echo "Starting blue"
docker-compose up -d backend-blue
command_blue=$(docker inspect -f {{.State.Health.Status}} $(docker ps  -q --filter="name=blue"))
until [ "$command_blue" == "healthy" ]
do
    sleep 1;
command_blue=$(docker inspect -f {{.State.Health.Status}} $(docker ps  -q --filter="name=blue"))
        echo "Blue is $command_blue";
done
docker-compose scale backend-blue=2 
  echo "Stoping green"
docker-compose stop backend-green
docker-compose rm -f backend-green
fi






