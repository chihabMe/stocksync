FROM node:20-alpine

WORKDIR /admin

COPY  package.json . 

RUN npm install

COPY   public .

COPY . . 

RUN npm run build

CMD [ "npm","run","preview","--host" ]