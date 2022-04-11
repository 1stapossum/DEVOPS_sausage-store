#FROM node:14.17.3
FROM node:16.9.1 as OLD
ARG VERSION=${VERSION}
ARG CI_PROJECT_DIR=${CI_PROJECT_DIR}
# Create app directory
WORKDIR /usr/src/app
COPY sausage-store-front-${VERSION}/public_html ./dist/frontend/public_html
#RUN npm install
RUN npm install -g http-server
#RUN npm run build
EXPOSE 80
ENTRYPOINT ["http-server", "dist/frontend/public_html", "-p", "80", "--proxy", "http://sausage-backend:8080"]


FROM nginxproxy/nginx-proxy as NEW
ARG VERSION=${VERSION}
COPY --from=OLD /usr/src/app/dist/frontend/public_html /usr/share/nginx/html/public_html
#COPY sausage-store-front-${VERSION}/public_html /usr/share/nginx/html/
COPY proxytemplate /app
#RUN docker-gen -only-exposed -watch -notify "/etc/init.d/nginx reload" /app/templ /etc/nginx/nginx.conf
#COPY nginx.conf /etc/nginx/nginx.conf