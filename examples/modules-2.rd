
module User {

  type {
    first_name: String
    last_name: String
    age: Integer
  }

  constructor(name: String) => {
    first_name, last_name, age = name.split()
    age = Integer(age)
    return User{first_name, last_name, age}
  }

  greet(user: User, greeting: String) => {
    say greeting ++ user.first_name
  }
}

"Simon Holloway 31" | User | User.greet("Hey")


