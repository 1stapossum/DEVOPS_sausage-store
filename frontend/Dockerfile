FROM node:16.9.1 as BUILD
WORKDIR /usr/src/app
COPY . .
RUN npm install
RUN npm run build
FROM nginx:latest as WORK
COPY --from=BUILD /usr/src/app/dist/frontend/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]