FROM debian:stable

MAINTAINER Raphael De Freitas <raphael@de-freitas.net>

ENV NODE_VERSION 10
ENV YARN_VERSION 1.12.3

# Installing default packgages
RUN apt-get update \
    && apt-get install -y curl gnupg

# Installing NodeJS
RUN curl -sL "https://deb.nodesource.com/setup_$NODE_VERSION.x" | bash - \
    && apt-get install -y nodejs

# Installing Yarn
RUN set -ex \
    && for key in \
        6A010C5166006599AA17F08146C2130DFD2497F5 \
    ; do \
        gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
        gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
    && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
    && mkdir -p /opt \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz

# Installing Nginx
ENV NGINX_WWW_DIR /var/www/html
RUN apt-get install -y nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Building the application
COPY . /root/app
RUN cd /root/app \
    && yarn install \
    && yarn run lint \
    #&& yarn run test \ ==> If tests are enabled, do not build if tests not pass
    && yarn run build \
    && yarn cache clean --force \
    && rm -rf $NGINX_WWW_DIR \
    && mv dist $NGINX_WWW_DIR \
    && cd /root \
    && rm -rf /root/app

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
