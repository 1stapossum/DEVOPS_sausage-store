FROM nginxproxy/nginx-proxy
COPY --from=sausage-frontend-nginx:${VERSION}  /usr/src/app/dist/frontend/public_html /etc/nginx/public_html