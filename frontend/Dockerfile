FROM node:alpine as todo-app-build

WORKDIR /client

COPY package.json yarn.lock README.md ./

RUN yarn

COPY ./public ./public

COPY ./src ./src

ENV REACT_APP_baseAPIURL = http://backend-service:5000
#<backend-app-service-ip>:<port>

RUN yarn build

FROM nginx:1-bullseye

LABEL maintainer=Aamir-Pinger

COPY --from=todo-app-build /client/build/ /usr/share/nginx/html

EXPOSE 80
