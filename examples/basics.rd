-- Hello World
say "Hello World"

-- Literal primitives
age = 42
name = "Steve"
living = True

-- String Interpolation & Multiline strings
say "Hello ${name}, you are ${age} years old
and you are ${living ? "living" : "dead"}"

-- Algrabraic data types
type Gender = Male | Female
gender = Male
say "You are ${gender}"

-- Tuples
teamMemberOne = ("John", 25)
teamMemberTwo = (
  "Jane"
  31
)
child = (name = "Rudiger", age = 2)
sister = (
  name = "Jenny"
  age = 5
)

-- Lists
drinks = ["Water", "Juice", "Chocolate"]
meals = [
  "Apple"
  "Orange"
  "Grapes"
]

-- Selection
if "Milk" in drinks then
  say "We have Milk and ${drinks->length - 1} other drinks on our menu"
else if "Milk" in meals then
  say "We have Milk and ${meals->length - 1} other meals on our menu"
else
  say "We have no Milk"

"Milk"->case
  (in drinks) => say "We have Milk and ${drinks->length - 1} other drinks on our menu"
  (in meals) => say "We have Milk and ${meals->length - 1} other meals on our menu"
  (Else) => say "We have no Milk"

-- Iteration
for drink in drinks do
  say "We have the drink ${drink}"

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

-- Pattern matching
result = myVar->case
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

-- Early return
result = somethingThatMayError()
if result is Error
  return result
say result

say somethingThatMayError()->case (error: Error) =>
  return error

say somethingThatMayError()?

-- Events
type SomethingHappened() =|
