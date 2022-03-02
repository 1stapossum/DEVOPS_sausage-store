#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт!!
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store-front.service /etc/systemd/system/sausage-store-front.service
#sudo rm -f /home/jarservice/sausage-store.jar||true
#Переносим артефакт в нужную папку
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o /home/student/sausage-store.tar.gz ${NEXUS_FRONTEND_REPO_URL}/sausage-store/${VERSION}/sausage-store-${VERSION}.tar.gz
rm -rf sausage-store-front
mkdir sausage-store-front
tar xzf sausage-store.tar.gz
cp sausage-store-${VERSION}/public_html/* sausage-store-front
rm -rf sausage-store-${VERSION}
#sudo cp ./sausage-store.jar /home/student/sausage-store.jar||true #"jar||true" говорит, если команда обвалится — продолжай
#Обновляем конфиг systemd с помощью рестарта!!!!!
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной!!
sudo systemctl restart sausage-store-front