#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт!!!
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store.service /etc/systemd/system/sausage-store.service
#sudo rm -f /home/jarservice/sausage-store.jar||true
#Переносим артефакт в нужную папку
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o /home/student/sausage-store.jar ${NEXUS_BACKEND_REPO_URL}/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.jar
#sudo cp ./sausage-store.jar /home/student/sausage-store.jar||true #"jar||true" говорит, если команда обвалится — продолжай
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной!!q
sudo systemctl restart sausage-store