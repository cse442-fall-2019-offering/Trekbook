FROM node:dubnium

RUN mkdir /src
WORKDIR /src

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080

CMD npm run dev
