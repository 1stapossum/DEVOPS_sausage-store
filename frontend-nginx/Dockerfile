FROM nginxproxy/nginx-proxy
COPY --from=sausage-frontend:${VERSION}  /usr/src/app/dist/frontend/public_html /etc/nginx/public_html