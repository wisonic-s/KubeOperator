FROM node:10-alpine as stage-build

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

WORKDIR /data

RUN apk add --no-cache git python2  build-base && \
    cd /tmp && \
    git clone --recursive https://github.com/sass/node-sass.git && \
    cd node-sass && \
    npm install --registry=https://registry.npm.taobao.org && \
    node scripts/build.js -f && \
    cp /tmp/node-sass/vendor/linux-arm64-64/binding.node /tmp/binding.node && \
    cd /tmp && \
    npm install node-sass --sass-binary-path=/tmp/binding.node

ADD ./package.json /data/package.json

RUN npm --registry=https://registry.npm.taobao.org --disturl=https://npm.taobao.org/dist install
ADD . /data
RUN npm run-script build

FROM nginx:alpine
COPY --from=stage-build /data/dist /opt/kubeOperator-ui
COPY nginx.conf /etc/nginx/conf.d/default.conf