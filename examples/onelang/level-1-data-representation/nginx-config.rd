user = {"www", "www"}  # Default: nobody
worker_processes = 5  # Default: 1
error_log = "logs/error.log"
pid = "logs/nginx.pid"
worker_rlimit_nofile = 8192

events.worker_connections = 4096  ## Default: 1024

http.include = "conf/mime.types"
http.include = "/etc/nginx/proxy.conf"
http.include = "/etc/nginx/fastcgi.conf"
http.index = ["index.html", "index.htm", "index.php"]

http.default_type = "application/octet-stream"
http.log_format.main = """
  $remote_addr - ${remote_user} [$time_local]  $status
  "$request" $body_bytes_sent "$http_referer"
  "$http_user_agent" "$http_x_forwarded_for"
  """

http.access_log = { path = "logs/access.log", format = "main" }
http.sendfile = True
http.tcp_nopush = True
http.server_names_hash_bucket_size = 128 # this seems to be required for some vhosts

http.server[] = { # php/fastcgi
  listen = 80
  server_name = ["domain1.com", "www.domain1.com"]
  access_log = { path = "logs/domain1.access.log", format = "main"}
  root = "html"

  location[] = {
    uri = "\.php\$",
    fastcgi_pass = "127.0.0.1:1025",
  }
}

http.server[] = { # simple reverse-proxy
  listen = 80
  server_name = ["domain2.com", "www.domain2.com"]
  access_log = { path = "logs/domain1.access.log", format = "main"}

  # serve static files
  location[] = {
    uri = "^/(images|javascript|js|css|flash|media|static)/"
    root = "/var/www/virtual/big.server.com/htdocs"
    expires = "30d"
  }

  # pass requests for dynamic content to rails/turbogears/zope, et al
  location[] = {
    uri = "/"
    proxy_pass = "http://127.0.0.1:8080"
  }
}

http.upstream.big_server_com = {
  server[] = { address = "127.0.0.3:8000", weight = 5 }
  server[] = { address = "127.0.0.3:8001", weight = 5 }
  server[] = { address = "192.168.0.1:8000" }
  server[] = { address = "192.168.0.1:8001" }
}

http.server[] = { # simple load balancing
  listen = 80
  server_name = "big.server.com"
  access_log = { path = "logs/big.server.access.log", format = "main"}

  location[] = {
    uri = "/",
    proxy_pass = "http://big_server_com"
  }
}

# VS

user       www www;  ## Default: nobody
worker_processes  5;  ## Default: 1
error_log  logs/error.log;
pid        logs/nginx.pid;
worker_rlimit_nofile 8192;

events {
  worker_connections  4096;  ## Default: 1024
}

http {
  include    conf/mime.types;
  include    /etc/nginx/proxy.conf;
  include    /etc/nginx/fastcgi.conf;
  index    index.html index.htm index.php;

  default_type application/octet-stream;
  log_format   main '$remote_addr - $remote_user [$time_local]  $status '
    '"$request" $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log   logs/access.log  main;
  sendfile     on;
  tcp_nopush   on;
  server_names_hash_bucket_size 128; # this seems to be required for some vhosts

  server { # php/fastcgi
    listen       80;
    server_name  domain1.com www.domain1.com;
    access_log   logs/domain1.access.log  main;
    root         html;

    location ~ \.php$ {
      fastcgi_pass   127.0.0.1:1025;
    }
  }

  server { # simple reverse-proxy
    listen       80;
    server_name  domain2.com www.domain2.com;
    access_log   logs/domain2.access.log  main;

    # serve static files
    location ~ ^/(images|javascript|js|css|flash|media|static)/  {
      root    /var/www/virtual/big.server.com/htdocs;
      expires 30d;
    }

    # pass requests for dynamic content to rails/turbogears/zope, et al
    location / {
      proxy_pass      http://127.0.0.1:8080;
    }
  }

  upstream big_server_com {
    server 127.0.0.3:8000 weight=5;
    server 127.0.0.3:8001 weight=5;
    server 192.168.0.1:8000;
    server 192.168.0.1:8001;
  }

  server { # simple load balancing
    listen          80;
    server_name     big.server.com;
    access_log      logs/big.server.access.log main;

    location / {
      proxy_pass      http://big_server_com;
    }
  }
}
