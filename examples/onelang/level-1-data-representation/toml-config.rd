title = "Roads Example 1"

owner.name = "Tom Preston-Werner"
owner.dob = "1979-05-27T07:32:00-08:00";

database.enabled = True
database.ports = [ 8000, 8001, 8002 ]
database.data = [ ["delta", "phi"], [3.14] ]
database.temp_targets = { cpu = 79.5, case = 72.0 }

servers.alpha.ip = "10.0.0.1"
servers.alpha.role = "frontend"

servers.beta.ip = "10.0.0.2"
servers.beta.role = "backend"

# VS

title = "Roads Example 2"

owner = {
  name = "Tom Preston-Werner"
  dob = "1979-05-27T07:32:00-08:00"
}

database = {
  enabled = True
  ports = [ 8000, 8001, 8002 ]
  data = [ ["delta", "phi"], [3.14] ]
  temp_targets = { cpu = 79.5, case = 72.0 }
}

servers.alpha = {
  ip = "10.0.0.1"
  role = "frontend"
}

servers.beta = {
  ip = "10.0.0.2"
  role = "backend"
}

# VS

title = "TOML Example"

[owner]
name = "Tom Preston-Werner"
dob = 1979-05-27T07:32:00-08:00

[database]
enabled = true
ports = [ 8000, 8001, 8002 ]
data = [ ["delta", "phi"], [3.14] ]
temp_targets = { cpu = 79.5, case = 72.0 }

[servers]

[servers.alpha]
ip = "10.0.0.1"
role = "frontend"

[servers.beta]
ip = "10.0.0.2"
role = "backend"

# VS

{
  "title": "JSON Example",
  "owner": {
    "dob": "1979-05-27T07:32:00-08:00",
    "name": "Tom Preston-Werner"
  },
  "database": {
    "data": [ [ "delta", "phi" ], [ 3.14 ] ],
    "enabled": true,
    "ports": [ 8000, 8001, 8002 ],
    "temp_targets": { "case": 72.0, "cpu": 79.5 }
  },
  "servers": {
    "alpha": {
      "ip": "10.0.0.1",
      "role": "frontend"
    },
    "beta": {
      "ip": "10.0.0.2",
      "role": "backend"
    }
  }
}
