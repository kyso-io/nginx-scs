#!/bin/sh
# Replace the default.conf nginx file by our own version.
set -e
# FUNCTIONS
print_no_auth_prefix_conf() {
  cat << EOF
server {
  listen       80;
  server_name  localhost;
  location $NO_AUTH_PREFIX {
    root  $HTML_ROOT;
    index index.html index.htm;
  }
  location / {
    auth_request /.auth;
    root  $HTML_ROOT;
    index index.html index.htm;
  }
  location /.auth {
    internal;
    proxy_pass $AUTH_REQUEST_URI;
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
}
print_auth_request_uri_conf() {
  cat << EOF
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
}
print_default_conf() {
  cat <<EOF
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
}
# MAIN
if [ -z "$HTML_ROOT" ]; then
  HTML_ROOT="/usr/share/nginx/html"
fi
if [ "$AUTH_REQUEST_URI" ]; then
  if [ "$NO_AUTH_PREFIX" ]; then
    print_no_auth_prefix_conf > /etc/nginx/conf.d/default.conf
  else
    print_auth_request_uri_conf > /etc/nginx/conf.d/default.conf
  fi
else
  print_default_conf > /etc/nginx/conf.d/default.conf
fi

# vim: ts=2:sw=2:et
