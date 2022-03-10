ARG NGINX_VERSION=latest
FROM registry.kyso.io/docker/nginx:$NGINX_VERSION
RUN rm -f /docker-entrypoint.d/*
COPY docker-entrypoint.d/* /docker-entrypoint.d/