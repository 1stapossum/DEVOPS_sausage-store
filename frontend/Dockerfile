#FROM node:14.17.3
FROM node:16.9.1
ARG VERSION=${VERSION}
# Create app directory
WORKDIR /usr/src/app
COPY sausage-store-front-${VERSION}/public_html .
#RUN npm install
#RUN npm install -g http-server
#RUN npm run build
EXPOSE 80
ENTRYPOINT ["http-server", "dist/frontend/", "-p", "80", "--proxy", "http://sausage-backend:8080"]
