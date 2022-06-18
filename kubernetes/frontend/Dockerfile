#FROM node:14.17.3
FROM node:16.9.1 as BUILD
# Create app directory
WORKDIR /usr/src/app
COPY . .
RUN npm install
#RUN npm install -g http-server
RUN npm run build
#EXPOSE 80
#ENTRYPOINT ["http-server", "dist/frontend/", "-p", "80", "--proxy", "http://sausage-backend:8080"]

FROM nginx:latest as WORK
COPY --from=BUILD /usr/src/app/dist/frontend/ /usr/share/nginx/html/
EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]
#ENTRYPOINT ["http-server", "dist/frontend/", "-p", "80", "--proxy", "http://sausage-backend:8080"]



