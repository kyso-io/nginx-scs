#!/bin/sh

# Replace the default.conf nginx file by our own version.

set -e

if [ -z "$HTML_ROOT" ]; then
  HTML_ROOT="/usr/share/nginx/html"
fi
if [ "$AUTH_REQUEST_URI" ]; then
  cat > /etc/nginx/conf.d/default.conf << EOF
server {
  listen       80;
  server_name  localhost;
  location / {
    auth_request /.auth;
    root  $HTML_ROOT;
    index index.html index.htm;
  }
  location /.auth {
    internal;
    proxy_pass $AUTH_REQUEST_URI;
    proxy_pass_header Authorization;
    proxy_pass_request_body off;
    proxy_set_header Content-Length "";
    proxy_set_header X-Original-URI \$request_uri;
  }
  error_page   500 502 503 504  /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}
EOF
else
  cat > /etc/nginx/conf.d/default.conf << EOF
server {
  listen       80;
  server_name  localhost;
  location / {
    root  $HTML_ROOT;
    index index.html index.htm;
  }
  error_page   500 502 503 504  /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}
EOF
fi

# vim: ts=4:sw=4:et
