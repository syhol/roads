-- Hello World
say "Hello World"

-- Literal primitives
age = 42
name = "Steve"
living = True

-- Multiline strings
say "Hello Steve, you are 42 years old
and you are alive"

-- String Interpolation
say "Hello ${name}, you are ${age} years old
and you are alive"

-- Handle nested quotes
say """Hello ${name}, you are ${age} years old
and you are ${if living then "alive" else "dead"}"""

-- Algrabraic data types
type Gender = Male | Female | Other{name: String}
myGender = Male
say "You are ${gender}"

-- Tuples
teamMemberOne = {"John", 25}
teamMemberTwo = {
  "Jane",
  31,
}
child = {name = "Rudiger", age = 2}
sister = {
  name = "Jenny",
  age = 5,
}

-- Lists
drinks = ["Water", "Juice", "Chocolate"]
meals = [
  "Apple"
  "Orange"
  "Grapes"
]

-- Selection
if "Milk" in drinks then
  say "We have Milk and ${drinks->count - 1} other drinks on our menu"
else if "Milk" in meals then
  say "We have Milk and ${meals->count - 1} other meals on our menu"
else
  say "We have no Milk"

"Milk"->case
  (in drinks) => say "We have Milk and ${drinks->count - 1} other drinks on our menu"
  (in meals) => say "We have Milk and ${meals->count - 1} other meals on our menu"
  (Else) => say "We have no Milk"

-- Iteration
drinks->each (drink) =>
  say "We have the drink ${drink}"

-- Functions
salary = 60
bonus = 50
add(a, b) => a + b
add(salary, bonus) -- > 110

-- Unified function call syntax
add(salary, bonus)
salary->add(bonus)
salary
  ->add(bonus)
add salary, bonus
add salary
  bonus
add
  salary
  bonus
salary->add bonus
salary->add
  bonus

-- Explicit typing
add2(a: Number, b: Number): Number => a + b

-- Pattern matching List
result = myVar->case
  [] => "Empty list"
  [a] => "List with 1 item"
  [7, ...a] => "List starting with 7 with ${a->count} other items"
  a => "List with ${a->count} items"

-- Pattern matching Tuple
result = myVar->case
  {Nothing, Nothing} => "Tuple with 2 nothing values"
  {a = 7, b = 8} => "Tuple where a is 7 and b is 8"
  {a, b} => "Pair of ${a} and ${b}"

-- Pattern matching Number
result = myVar->case
  42 => "Answer to life the universe and everything"
  in 18.. => "Old enough to drink beer"
  in 16..18 => "Old enough to sneek into a bar"
  in 0,2.. => "Even number"
  a => "Number of value: ${a}"

-- Pattern matching String
result = myVar->case
  "dave" => "String of dave"
  "${start}foo${end}" => "String contains foo"
  "foo${end}" => "String starts with foo"
  a => "String containing: ${a}"

-- Pattern matching Boolean
result = myVar->case
  True => "Its a true"
  a => "Boolean of ${a}"
  Else => "Not sure"

-- Early return
result = somethingThatMayError()
if result is Error then
  return result
say result

say somethingThatMayError()->case (error: Error) =>
  return error

say somethingThatMayError()?

say somethingThatMayError()->default("Whoops, Something went wrong")

-- Events
type SomethingHappened
