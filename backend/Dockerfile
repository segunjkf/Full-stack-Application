FROM node:21.2-alpine3.18

WORKDIR /server

COPY package*.json yarn.lock ./

RUN yarn

COPY ./src ./src

EXPOSE 5000

CMD [ "yarn", "start" ]
