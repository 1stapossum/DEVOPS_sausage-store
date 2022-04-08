FROM nginxproxy/nginx-proxy
ARG VERSION=${VERSION}
COPY --from=sausage-frontend:${VERSION}  /usr/src/app/dist/frontend/public_html /etc/nginx/public_html