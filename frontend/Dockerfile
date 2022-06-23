FROM nginx:latest as WORK
ARG VERSION=${VERSION}
COPY sausage-store-front-${VERSION}/public_html /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]