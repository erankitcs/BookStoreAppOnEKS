# Stage -1
FROM node:12.14-alpine as buid
RUN mkdir -p /bookstore
WORKDIR /bookstore
COPY bookstore/package.json bookstore/package-lock.json ./
RUN npm install
COPY bookstore/ ./
RUN npm run build

# Stage-2
FROM nginx:1.20-alpine
COPY --from=buid /bookstore/dist/bookstore /usr/share/nginx/html
COPY bookstore/nginx.conf /etc/nginx/conf.d/default.conf
