FROM node:current-alpine

WORKDIR /home

COPY src ./src
COPY package.json .
RUN npm install

ENTRYPOINT [ "npm", "start" ]