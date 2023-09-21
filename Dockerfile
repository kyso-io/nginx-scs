ARG NGINX_VERSION=1.23.1-alpine
FROM kyso/nginx-kyso:1.23.1-alpine
RUN rm -f /docker-entrypoint.d/*
COPY docker-entrypoint.d/* /docker-entrypoint.d/
