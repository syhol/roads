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