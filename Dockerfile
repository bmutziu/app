FROM node:14-alpine as react-build
LABEL maintainer "Krateo <contact@krateoplatformops.io>"

ARG VERSION

RUN apk add g++ make py3-pip

WORKDIR /app
COPY . ./
RUN yarn
RUN npm version $VERSION
RUN PUBLIC_URL=https://app.bmutziu.me yarn build

# server environment
FROM bitnami/nginx

COPY --from=react-build /app/build /app

ENV PORT 8080
EXPOSE 8080
# COPY nginx.conf /opt/bitnami/nginx/conf/server_blocks/my_server_block.conf
COPY nginx.conf /opt/bitnami/nginx/conf/bitnami/location.conf
CMD ["nginx", "-g", "daemon off;"]
