#!/bin/bash
set +e
docker network create -d bridge sausage_network || true
docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}

#sleep 5
docker-compose pull
#docker-compose up -d
docker-compose up -d backend-report
docker-compose up -d frontend
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
sleep 15
bash ihatevault.sh
docker exec -d  sausage-frontend docker-gen -only-exposed -watch -notify "/etc/init.d/nginx reload" /app/proxytemplate /etc/nginx/nginx.conf

#BACKEND RUN CHECK
command1=$(docker ps -aq  --filter status=running --filter="name=green")
command2=$(docker ps -aq  --filter status=running --filter="name=blue")
#echo "$command1"
#echo "$command2"
if [[ ! -z $command1 ]] || [[ ! -z $command2 ]]; then
echo "BACK is up"
else 
docker-compose up --scale backend-blue=2 -d
exit 0
fi


### BLUE/GREEN
#source var
#CONTAINER_RUN_CHECK=$(docker container  ls -q )
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
docker-compose up --scale backend-green=1 -d

command=$(docker inspect -f {{.State.Health.Status}} $(docker ps  -q --filter="name=green"))
until [ "$command" == "healthy" ] 
do
    sleep 0.1;
command=$(docker inspect -f {{.State.Health.Status}} $(docker ps  -q --filter="name=green"))
	echo $command;
done
docker-compose up --scale backend-green=2 -d
  echo "Stoping blue!"
#  docker stop $(docker ps  -q --filter="name=blue")a
docker-compose stop backend-blue
docker-compose rm -f backend-blue

elif [[ $CONTAINER_RUN_CHECK_ALL == *"green"* ]]; then
  echo "Green backend runing"

echo "Stoping blue"
#  docker stop $(docker ps  -q --filter="name=blue")
docker-compose stop backend-blue
docker-compose rm -f backend-blue
docker-compose pull backend-blue #budem schitat chto pull
echo "Starting blue"
docker-compose up --scale backend-blue=1 -d
command=$(docker inspect -f {{.State.Health.Status}} $(docker ps  -q --filter="name=blue"))
until [ "$command" == "healthy" ]
do
    sleep 0.1;
command=$(docker inspect -f {{.State.Health.Status}} $(docker ps  -q --filter="name=blue"))
        echo $command;
done
 docker-compose up --scale backend-blue=2 -d
echo "Stoping green"
docker-compose stop backend-green
docker-compose rm -f backend-green
fi





