_: List({
  name: String
  "last name": String
  dob: Integer
  nickname: String
  instruments: List(String)
})
_[] = {"Saul", "Hudson", 1965, "Slash", ["guitar"]}
_[] = {"William", "Bailey", 1962, "Axl Rose", ["vocals", "piano"]}

_[] = {
  name = "William"
  "last name" = "Bailey"
  dob = 1962
  nickname = "Axl Rose"
  instruments = [
    "vocals"
    "piano"
  ]
}

_[] = {
  name = "Saul"
  "last name" = "Hudson"
  dob = 1965
  nickname = "Slash"
  instruments: = [
    "guitar"
  ]
}
