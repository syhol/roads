
io_mode = "async"

service.http.web_proxy = {
  listen_addr = "127.0.0.1:8080"

  process.main = {
    command = ["/usr/local/bin/awesome-app", "server"]
  }

  process.mgmt = {
    command = ["/usr/local/bin/awesome-app", "mgmt"]
  }
}

# OR

io_mode = "async"
service.http.web_proxy = {
  listen_addr = "127.0.0.1:8080"
  process = {
    main.command = ["/usr/local/bin/awesome-app", "server"]
    mgmt.command = ["/usr/local/bin/awesome-app", "mgmt"]
  }
}

# OR

io_mode = "async"
service.http.web_proxy.listen_addr = "127.0.0.1:8080"
service.http.web_proxy.process."main".command = ["/usr/local/bin/awesome-app", "server"]
service.http.web_proxy.process."mgmt".command = ["/usr/local/bin/awesome-app", "mgmt"]

# VS

io_mode = "async"

service "http" "web_proxy" {
  listen_addr = "127.0.0.1:8080"

  process "main" {
    command = ["/usr/local/bin/awesome-app", "server"]
  }

  process "mgmt" {
    command = ["/usr/local/bin/awesome-app", "mgmt"]
  }
}

# VS

{
  "io_mode": "async",
  "service": {
    "http": {
      "web_proxy": {
        "listen_addr": "127.0.0.1:8080",
        "process": {
          "main": {
            "command": ["/usr/local/bin/awesome-app", "server"]
          },
          "mgmt": {
            "command": ["/usr/local/bin/awesome-app", "mgmt"]
          },
        }
      }
    }
  }
}
