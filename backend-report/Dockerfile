#FROM maven:3.8-openjdk-16 as builder
#Create build directory
#ARG VERSION
#WORKDIR /usr/src/app
#COPY . .
#RUN mvn package -DskipTests -Dversion.application=${VERSION}

FROM openjdk:16-jdk-alpine

ARG VERSION
#Create app directory
WORKDIR /usr/src/app

RUN wget https://storage.yandexcloud.net/cloud-certs/CA.pem -O YandexInternalRootCA.crt && \
    keytool -importcert -file YandexInternalRootCA.crt -alias yandex -cacerts -storepass changeit -noprompt && \
    rm -f YandexInternalRootCA.crt  \
    && addgroup --system jaruser \
    && adduser -S -s /bin/false -G jaruser jaruser -D -H \
    && apk add --no-cache dumb-init==1.2.5-r0

#COPY --from=builder /usr/src/app/target/sausage-store-report-${VERSION}.jar sausage-store-report.jar
COPY --chown=jaruser:jaruser backend-report-${VERSION}/sausage-store-report-${VERSION}.jar sausage-store-report.jar

ENTRYPOINT ["java", "-jar", "./sausage-store-report.jar", "--service.port=8081"]
EXPOSE 8081