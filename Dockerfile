FROM node:current-alpine

WORKDIR /home

COPY package.json .
RUN npm install

COPY src ./src
RUN npm run build

ENTRYPOINT [ "npm", "start" ]