FROM node:23.11.1-alpine3.21

WORKDIR /server

COPY package*.json yarn.lock ./

RUN yarn

COPY ./src ./src

EXPOSE 5000

CMD [ "yarn", "start" ]
