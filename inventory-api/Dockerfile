FROM node:10
WORKDIR /usr/src/app
COPY src/package*.json ./

RUN npm install
COPY src .
EXPOSE 5001
CMD node app.js