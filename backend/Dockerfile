FROM node:21.6.0-alpine3.19

WORKDIR /server

COPY package*.json yarn.lock ./

RUN yarn

COPY ./src ./src

EXPOSE 5000

CMD [ "yarn", "start" ]
