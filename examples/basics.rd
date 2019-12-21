# Hello World
say "Hello World"

# Literal primitives
age = 42
name = "Steve"
living = True

# String Interpolation & Multiline strings
say "Hello ${name}, you are ${age} years old
and you are ${living ? "living" : "dead"}"

# Algrabraic data types
type Gender = Male | Female
gender = Male
say "Are you ${gender}?"

# Tuples
teamMemberOne = ("John", 25)
teamMemberTwo =
  "Jane"
  31
child = (name = "Rudiger", age = 2)
sister =
  name = "Jenny"
  age = 5

# Lists
drinks = ["Water", "Juice", "Chocolate"]
food = [
  "Apple"
  "Orange"
  "Grapes"
]

# Selection
if "Milk" in drinks
  say "We have Milk and ${drinks->length - 1} other drinks"
else if "Milk" in food
  say "We have Milk and ${food->length - 1} other food"
else
  say "We have no Milk"

"Milk"->case
  (in drinks) => say "We have Milk and ${drinks->length - 1} other drinks"
  (in food) => say "We have Milk and ${food->length - 1} other food"
  (else) => say "We have no Milk"

# Iteration
for drink in drinks
  say "We have the drink ${drink}"

drinks->each (drink) =>
  say "We have the drink ${drink}"

# Functions
age = 60
yearsUntilRetirement = 5
add = (a, b) => a + b
add(age, yearsUntilRetirement)

# Unified function call syntax
add(age, yearsUntilRetirement)
age->add(yearsUntilRetirement)
add age, yearsUntilRetirement
add age
  yearsUntilRetirement
add
  age
  yearsUntilRetirement
age->add yearsUntilRetirement
age->add
  yearsUntilRetirement

# Explicit typing
add2 = (a: int, b: int): int => a + b

# Pattern matching
myVar->case
  [] => "Empty list"
  [a] => "List with 1 item"
  [...a] => "List with ${a.length} items"
  () => "Empty tuple"
  (a, b) => "Pair"
  "dave" => "String of dave"
  42 => "Answer to life the universe and everything"
  18.. => "Old enough to drink beer"
  16..18 => "Old enough to sneek into a bar"
  0,2.. => "Even number"
  (a: String) => "String containing: ${a}"
  (a: Number) => "Number of value: ${a}"
  (a: Boolean) => "Boolean of ${a}"
  (Else) => "Not sure"

# Early return
result = somethingThatMayError()
if result is Error
  return result
say result

say somethingThatMayError()->case (error: Error) =>
  return error

say somethingThatMayError()?