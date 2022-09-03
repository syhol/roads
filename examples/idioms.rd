
// 1. Print Hello World
// Print a literal string on standard output
say("Hello World")

// 2. Print Hello 10 times
// Loop to execute some code a constant number of times
1..10->each(() => say("Hello"))

// 3. Create a procedure
// Like a function which doesn't return any value,
// thus has only side effects (e.g. Print to standard output)
finish(name: String) =>
  say("My job here is done. Goodbye ${name}")

// 4. Create a function which returns the square of an integer
square(x: Integer): Integer => x * x

// 5. Create a 2D Point data structure
// Declare a container type for two floating-point numbers x and y
type Point{x: Float, y: Float}

// 6. Iterate over list values
// Do something with each item x of an array-like collection items, regardless indexes.
items->each (x) =>
    do_something(x)

// 7. Iterate over list indexes and values
// Print each index i with its value x from an array-like collection items
items->indexed()->each ({i, x}) =>
    say("Item ${i} = ${x}")

// 8. Initialize a new map (associative array)
// Create a new map object x, and provide some (key, value) pairs as initial content.
x = [{"one", 1}, {"two": 2}]->unpairs()
x = {one, 1, two: 2}->toMap()

// 9. Create a Binary Tree data structure
// The structure must be recursive because left child and right child are
// binary trees too. A node has access to children nodes, but not to its parent.
type BinTree<T> =
 | Node{value: T, left: BinTree<T>, right: BinTree<T>}
 | EmptyNode

// 10. Shuffle a list
// Generate a random permutation of the elements of list x
x->shuffled()

// 11. Pick a random element from a list
// List x must be non-empty.
x->randomElement()

// 12. Check if list contains a value
// Check if list contains a value x.
list->contains(x)

// 13. Iterate over map keys and values
// Access each key k with its value x from an associative array mymap, and print them.
map->pairs->each ({key, value}) =>
  say("Key=${key}, Value=${value}")

// 14. Pick uniformly a random floating point number in [a..b)
// Pick a random number greater than or equals to a, strictly inferior to b. Precondition : a < b.
pick(a: Float, b: Float): Float => (a..b)->randomElement()

// 15. Pick uniformly a random integer in [a..b]
// Pick a random integer greater than or equals to a, inferior or equals to b. Precondition : a < b.
pick(a: Integer, b: Integer): Integer => (a..b)->randomElement()

// 17. Create a Tree data structure
// The structure must be recursive. A node may have zero or more children. A node has access to children nodes, but not to its parent.
type Tree<T>{value: T, children: List<Tree<T>>}

// 18. Depth-first traversing of a tree
// Call a function f on every node of a tree, in depth-first prefix order
type Tree<T>{value: T, children: List<Tree<T>>}
implement Iterable for Tree
  each(tree, fn) =>
    fn(tree)
    tree.children->each(fn)

// 19. Reverse a list
// Reverse the order of the elements of list x.
// This may reverse "in-place" and destroy the original ordering.
x->reversed()

// 20. Return two values
// Implement a function search which looks for item x in a 2D matrix m.
// Return indices i, j of the matching cell.
// Think of the most idiomatic way in the language to return the two values at the same time.
search<T: Eq>(m: List<List<T>>, x: T): Optional<{Integer, Integer}> =>
  m->pairs()->tryPick ({i, row}) =>
    row->pairs()->tryPick ({j, column}) =>
      if column == x then Just{{i, j}} else None

// 21. Swap values
// Swap values of variables a and b
{a, b} = {b, a}

// 22. Convert string to integer
// Extract integer value i from its string representation s (in radix 10)
s->tryToInteger()->default(0)
s->toInteger()

// 23. Convert real number to string with 2 decimal places
// Given real number x, create its string representation s with 2 decimal digits following the dot.
x->toStringWithPrecision(2)

// 24. Assign to string the japanese word ネコ
// Declare a new string s and initialize it with the literal value "ネコ" (which means "cat" in japanese)
s = "ネコ"

// 25. Send a value to another thread
// Share the string value "Alan" with an existing running process which will then display "Hello, Alan"
personGreeter = spawn () =>
    receive Person{name} => say("Hello, ${name}")
    this()
});

personGreeter->send(Person{"Alan"})

// 26. Create a 2-dimensional array
// Declare and initialize a matrix x having m rows and n columns, containing real numbers.
x: List<List<Integer>> = (1..m)
  ->map(() => (1..n)
    ->map(() => 1)
    ->toList()
  )
  ->toList()

// 27. Create a 3-dimensional array
// Declare and initialize a 3D array x, having dimensions boundaries m, n, p, and containing real numbers.
x: List<List<List<Integer>>> = (1..m)
  ->map(() => (1..n)
    ->map(() => (1..p)
      ->map(() => 1)
      ->toList()
    )
    ->toList()
  )
  ->toList()

// 28. Sort by a property
// Sort elements of array-like collection items in ascending order of x.p, where p is a field of the type Item of the objects in items.
items->sortByKey((x) => x.p)

// 29. Remove item from list, by its index
// Remove i-th item from list items.
items->removeAt(i)

// 30. Parallelize execution of 1000 independent tasks
// Launch the concurrent execution of procedure f with parameter i from 1 to 1000.
threads: List<Promise> = (1..1000)->map (i) => spawn () => f(i)
threads->concat()->await()

// 31. Recursive factorial (simple)
// Create recursive function f which returns the factorial of non-negative integer i, calculated from f(i-1)
factorial(num: Integer): Integer => num->case
  in [0, 1] => 1
  _ => factorial(num - 1) * num

// 32. Integer exponentiation by squaring
// Create function exp which calculates (fast) the value x power n.
exp(x: Integer, n: Integer): Integer => n->case
  0 => 1
  1 => x
  i if i % 2 == 0 => exp(x * x, n / 2)
  _ => x * exp(x * x, (n - 1) / 2)

// 33. Atomically read and update variable
// Assign variable x the new value f(x), making sure that no other thread may modify x between the read and the write.
x = f(x)

// 34. Create a set of objects
// Declare and initialize a set x containing objects of type T.
x = Set<T>
x = <T>[]->toSet()

// 35. First-class function : compose
// Implement a function compose (A -> C) with parameters f (A -> B) and g (B -> C), which returns composition function g ∘ f
compose<A, B, C>(a: (a: A) => B, b: (b: B) => C): ((a: A) => C) => (x: A) => b(a(x))

// 36. First-class function : generic composition
// Implement a function compose which returns composition function g ∘ f for any functions f and g having exactly 1 parameter.
compose<A, B, C>(a: (a: A) => B, b: (b: B) => C): ((a: A) => C) => (x: A) => b(a(x))

// 37. Currying
// Transform a function that takes multiple arguments into a function for which some of the arguments are preset.
add(a: Integer, b: Integer): Integer => a + b
add5 = (x) => add(5, x);

// 38. Extract a substring
// Find substring t consisting in characters i (included) to j (excluded) of string s.
// Character indices start at 0 unless specified otherwise.
// Make sure that multibyte characters are properly handled.
t = s->subSequence(i..<j)

// 39. Check if string contains a word
// Set boolean ok to true if string word is contained in string s as a substring, or to false otherwise.
s->contains(a)

// 41. Reverse a string
// Create string t containing the same characters as string s, in reverse order.
// Original string s must remain unaltered. Each character must be handled correctly regardless its number of bytes in memory.
s->reversed()

// 42. Continue outer loop
// Print each item v of list a which in not contained in list b.
// For this, write an outer loop to iterate on a and an inner loop to iterate on b.
a->each (v) => b
  ->tryPick (w) => if v === w then Just{w} else None
  ->defaultDo () => say("${v} not in the list")

// 43. Break outer loop
// Look for a negative value v in 2D integer matrix m. Print it and stop searching.
m->tryPick (line) => line
  ->tryPick (v) => if v < 0 then say(w); Just{w} else None

// 44. Insert element in list
// Insert element x at position i in list s. Further elements must be shifted to the right.
s->insert(i, x)

// 45. Pause execution for 5 seconds
// Sleep for 5 seconds in current thread, before proceeding with next instructions.
#SetTimeout{5->Seconds, self}
receive Timeout => True
5->Seconds->sleep
sleep 5->Seconds

// 46. Extract beginning of string (prefix)
// Create string t consisting of the 5 first characters of string s.
// Make sure that multibyte characters are properly handled.
t->take(5)

// 47. Extract string suffix
// Create string t consisting in the 5 last characters of string s.
t->takeLast(5)

// 48. Multi-line string literal
// Assign to variable s a string literal consisting in several lines of text, including newlines.
s = "line 1
line 2
line 3"

// 49. Split a space-separated string
// Build list chunks consisting in substrings of input string s, separated by one or more space characters.
s->split(" ")

// 50. Make an infinite loop
// Write a loop which has no end clause.
loop() => loop()
loop()

// 51. Check if map contains key
// Determine whether map m contains an entry for key k
m->containsKey(k)

// 52. Check if map contains value
// Determine whether map m contains an entry with value v, for some key.
m->contains(k)

// 53. Join a list of strings
// Concatenate elements of string list x joined by the separator ", " to create a single string y.
y = x->join(", ")

// 54. Compute sum of integers
// Calculate the sum s of integer list x.
s = x->reduce(add, 0)
s = x->sum()

// 55. Convert integer to string
// Create the string representation s (in radix 10) of integer value i.
s = i->toString()

// 56. Launch 1000 parallel tasks and wait for completion
// Fork-join : launch the concurrent execution of procedure f with parameter i from 1 to 1000.
// Tasks are independent and f(i) doesn't return any value.
// Tasks need not run all at the same time, so you may use a pool.
// Wait for the completion of the 1000 tasks and then print "Finished".
threads: List<Promise> = (1..1000)->map (i) => spawn () => f(i)
threads->concat()->await()
say("Finished.")

// 57. Filter list
// Create list y containing items from list x satisfying predicate p. Respect original ordering. Don't modify x in-place.
y = x->filter(p)

// 58. Extract file content to a string
// Create string lines from the content of the file with filename f.
line = read(f)?

// 59. Write to standard error stream
// Print the message "x is negative" to standard error (stderr), with integer x value substitution (e.g. "-2 is negative").
stderr->write("${x} is negative\n")

// 60. Read command line argument
// Assign to x the string value of the first command line parameter, after the program name.
#GetCommandLineArgs{self}
x = receive CommandLineArgs{words} => words->elementAt(0)
x = getArgs()->elementAt(1)
x = getArg(1)

// 61. Get current date
// Assign to variable d the current date/time value, in the most standard type.
#GetCurrentDateTime{self}
d = receive CurrentDateTime{date} => date
d = now()

// 62. Find substring position
// Set i to the position of string y inside string x, if exists.
i = x->indexOf(y)

// 63. Replace fragment of a string
// Assign to x2 the value of string x with all occurrences of y replaced by z.
// Assume occurrences of y are not overlapping.
x2 = x->replace(y, z);

// 64. Big integer : value 3 power 247
// Assign to x the value 3^247
x = 3->power(247)

// 65. Format decimal number
// From real value x in [0,1], create its percentage string representation s with one digit after decimal point. E.g. 0.15625 -> "15.6%"
s = (x * 100.0)->toStringWithPrecision(1) ++ "%"

// 66. Big integer exponentiation
// Calculate the result z of x power n, where x is a big integer and n is a positive integer.
z = x->power(n)

// 67. Binomial coefficient "n choose k"
// Calculate binom(n, k) = n! / (k! * (n-k)!). Use an integer type able to handle huge numbers.
fac(x: Integer): Integer =>
  if x then x * fac (x - 1) else x + 1
binom(n: Integer, k: Integer): Integer =>
  fac (n) / fac (k) / fac (if n - k >= 0 then n - k else NaN)

// 68. Create a bitset
// Create an object x to store n bits (n being potentially large).
x = <<: size=n>> ??????

// 69. Seed random generator
// Use seed s to initialize a random generator.
// If s is constant, the generator output will be the same each time the program runs. If s is based on the current value of the system clock, the generator output will be different each time.
#SetSeed{Seed{s}}

// 70. Use clock as random generator seed
// Get the current datetime and provide it as a seed to a random generator. The generator sequence will be different at each run.
#SetSeed{Seed{now()->inUnixMicroseconds()}}
#SetSeed{randomSeed()}
setRandomSeed()

// 71. Echo program implementation
// Basic implementation of the Echo program: Print all arguments except the program name, separated by space, followed by newline.
// The idiom demonstrates how to skip the first argument if necessary, concatenate arguments as strings, append newline and print it to stdout.
getArgs()->skip(1)->join(" ")->say()

// 74. Compute GCD
// Compute the greatest common divisor x of big integers a and b. Use an integer type able to handle huge numbers.
gcd(a: Integer, b: Integer): Integer => if b == 0 then a else gcd(b, a % b)

// 75. Compute LCM
// Compute the least common multiple x of big integers a and b. Use an integer type able to handle huge numbers.
gcd(a: Integer, b: Integer): Integer => if b == 0 then a else gcd(b, a % b)
x = (a * b) / gcd(a, b)

// 76. Binary digits from an integer
// Create the string s of integer x written in base 2.
s = x->toStringWithBase(2)

// 77. Complex number
// Declare a complex x and initialize it with value (3i - 2). Then multiply it by i.
x = Complex{3} - 2 ??????
y *= x * Complex{1}

// 78. "do while" loop
// Execute a block once, then execute it again as long as boolean condition c is true.
doWhile() =>
  something()
  if c then doWhile() else {}

// 79. Convert integer to floating point number
// Declare floating point number y and initialize it with the value of integer x .
y = x->toFloat()

// 80. Truncate floating point number to integer
// Declare integer y and initialize it with the value of floating point number x . Ignore non-integer digits of x .
// Make sure to truncate towards zero: a negative x must yield the closest greater integer (not lesser).
y = x->toInteger()

// 81. Round floating point number to integer
// Declare integer y and initialize it with the rounded value of floating point number x .
// Ties (when the fractional part of x is exactly .5) must be rounded up (to positive infinity).
y = x->round()

// 82. Count substring occurrences
// Find how many times string s contains substring t.
// Specify if overlapping occurrences are counted.
c = s->matches(t)->count()

// 83. Regex with character repetition
// Declare regular expression r matching strings "http", "htttp", "httttp", etc.
r = /htt+p/

// 84. Count bits set in integer binary representation
// Count number c of 1s in the integer i in base 2.
c = i->toStringWithBase(2)->matches("1")->count()

// 85. Check if integer addition will overflow
// Write boolean function addingWillOverflow which takes two integers x, y and return true if (x+y) overflows.
// An overflow may be above the max positive value, or below the min negative value.
addingWillOverflow(x: Integer, y: Integer): Boolean =>
  x->checkedAdd(y)->case
    None => True
    _ => False

// 86. Check if integer multiplication will overflow
// Write boolean function multiplyWillOverflow which takes two integers x, y and return true if (x*y) overflows.
// An overflow may be above the max positive value, or below the min negative value.
addingWillOverflow(x: Integer, y: Integer): Boolean =>
  x->checkedMultiply(y)->case
    None => True
    _ => False

// 87. Stop program
// Exit immediatly.
// If some extra cleanup work is executed by the program runtime (not by the OS itself), describe it.
type Exit{
  code: Integer
  reason: String
}
#Exit
exit()
#Exit{0, "Success"}
exit(0, "Success")

// 88. Allocate 1M bytes
// Create a new bytes buffer buf of size 1,000,000.
x = <<: size=1_000_000>> ??????

// 89. Handle invalid argument
// You've detected that the integer value of argument x passed to the current function is invalid. Write the idiomatic way to abort the function execution and signal the problem.
type InvalidAnswer{}
doStuff(x: Integer): Result<Integer, InvalidAnswer> =>
  if x != 42 then
    Error(InvalidAnswer)
  else
    Ok(x)

// 90. Read-only outside
// Expose a read-only integer x to the outside world while being writable inside a structure or a class Foo.
fooConstructor(value: Integer): Never =>
  receive
    GetState =>
      #State{value}
      self(value)
    Increment =>
      self(value + 1)

makeFoo() =>
  foo = fooConstructor(0)&
  {
    get() => foo->send(GetState)->receive State{value} => value
    increment() => foo->send(Increment)
  }

// 91. Load JSON file into struct
// Read from file data.json and write its content into object x.
// Assume the JSON data is suitable for the type of x.
type FooBar{
  @Json('foo_bar')
  fooBar: Integer
}
x = openFile("data.json")?->toJson()
x = openFile("data.json")?->toJson()->unmarshal<FooBar>()

// 92. Save object into JSON file
// Write content of object x into file data.json.
x->toJson()->toByteStream()->writeToPath("data.json")
x->toJson()->toByteStream()->write(to = openFile("data.json"))

// 93. Pass a runnable procedure as parameter
// Implement procedure control which receives one parameter f, and runs f.
control<T>(f: () => T) => f()

// 94. Print type of variable
// Print the name of the type of x. Explain if it is a static type or dynamic type.
??????

// 95. Get file size
// Assign to variable x the length (number of bytes) of the local file at path.
openFile("data.json")->fileSize()
fileStats("data.json").size

// 96. Check string prefix
// Set boolean b to true if string s starts with prefix prefix, false otherwise.
b = s->startsWith(prefix)

// 97. Check string suffix
// Set boolean b to true if string s ends with string suffix, false otherwise.
b = s->endsWith(suffix)

// 98. Epoch seconds to date object
// Convert a timestamp ts (number of seconds in epoch-time) to a date with time d. E.g. 0 -> 1970-01-01 00:00:00
d = ts->dateFromUnixSeconds()

// 99. Format date YYYY-MM-DD
// Assign to string x the value of fields (year, month, day) of date d, in format YYYY-MM-DD.
x = d->formatDate("%Y-%m-%d")

// 100. Sort by a comparator
// Sort elements of array-like collection items, using a comparator c.
x = items->sortBy(c)

// 101. Load from HTTP GET request into a string
// Make an HTTP request with method GET to URL u, then store the body of the response in string s.
s = Request{url = u}->sendHttpRequest()?.body->toString()
s = http.client.get(u)?.body->toString()

// 102. Load from HTTP GET request into a file
// Make an HTTP request with method GET to URL u, then store the body of the response in file result.txt. Try to save the data as it arrives if possible, without having all its content in memory at once.
s = Request{url = u}->sendHttpRequest()?.body->writeToPath("result.txt")
s = http.client.get(u).body->writeToPath("result.txt")

// 105. Current executable name
// Assign to string s the name of the currently executing program (but not its full path).
path = getArg(0)
s = Path.which(path)

// 106. Get program working directory
// Assign to string dir the path of the working directory.
// (This is not necessarily the folder containing the executable itself)
#GetCurrentWorkingDirectory
dir = receive CurrentWorkingDirectory{dir} => dir
dir = currentWorkingDirectory()

// 107. Get folder containing current program
// Assign to string dir the path of the folder containing the currently running executable.
// (This is not necessarily the working directory, though.)

// 110. Check if string is blank
// Set boolean blank to true if string s is empty, or null, or contains only whitespace ; false otherwise.
blank = s->trim()->isEmpty()

// 111. Launch other program
// From current process, run program x with command-line parameters "a", "b".
createProcess("x", ["a", "b"])

// 112. Iterate over map entries, ordered by keys
// Print each key k with its value x from an associative array mymap, in ascending order of k.
mymap
  ->pairs()
  ->sortByKey ({key, _}) => key
  ->each ({key, value}) => say "Key = ${key}, Value = ${value}"

// 113. Iterate over map entries, ordered by values
// Print each key k with its value x from an associative array mymap, in ascending order of x.
// Note that multiple entries may exist for the same value x.
mymap
  ->pairs()
  ->sortByKey ({_, value}) => value
  ->each ({key, value}) => say "Key = ${key}, Value = ${value}"

// 114. Test deep equality
// Set boolean b to true if objects x and y contain the same values, recursively comparing all referenced elements in x and y.
// Tell if the code correctly handles recursive types.
b = x == y

// 115. Compare dates
// Set boolean b to true if date d1 is strictly before date d2 ; false otherwise.
b = d1 < d2

// 116. Remove occurrences of word from string
// Remove all occurrences of string w from string s1, and store the result in s2.
s2 = s1->replace(w, '')

// 117. Get list size
// Set n to the number of elements of list x.
n = x->count()

// 118. List to set
// Create set y from list x.
// x may contain duplicates. y is unordered and has no repeated values.
y = x->toSet()

// 119. Deduplicate list
// Remove duplicates from list x.
// Explain if original order is preserved.
x = x->toSet()->toList()
x = x->unique
x = x->sort->deduplicate

// 120. Read integer from stdin
// Read an integer value from the standard input into variable n
n = stdin->readLine->tryToInteger()?

// 121. UDP listen and read
// Listen UDP traffic on port p and read 1024 bytes into buffer b.
let socket = UdpSocket.bind("localhost", p)?
b = socket->readBytes(1024)?

// 122. Declare enumeration
// Create an enumerated type Suit with 4 possible values SPADES, HEARTS, DIAMONDS, CLUBS.
type Suit = Spades | Hearts | Diamonds | Clubs

// 123. Assert condition
// Verify that predicate isConsistent returns true, otherwise report assertion violation.
// Explain if the assertion is executed even in production environment or not.
if !isConsistent then exit(1, "State consistency violated")

// 124. Binary search for a value in sorted array
// Write function binarySearch which returns the index of an element having value x in sorted array a, or -1 if no such element.
binarySearch<T: Eq>(a: List<T>, x: T, i = 0): Integer =>
  if a->count == 0 then return -1
  half = a->count / 2
  a->elementAt(half)->case
    e if e == x => i + half
    e if e > x => a->take(half)->binarySearch(x, i)
    e => a->skip(half + 1)->binarySearch(x, half + i + 1)

// 125. Measure function call duration
// measure the duration t, in nano seconds, of a call to the function foo. Print this duration.
start = now()
foo()
(now() - start)->say

// 126. Multiple return values
// Write a function foo that returns a string and a boolean value.
foo(): {String, Boolean} =>
  {"bar", true}

// 128. Breadth-first traversing of a tree
// Call a function f on every node of a tree, in breadth-first prefix order
type BreadthFirstTree<T>{
  value: T,
  children: List<BreadthFirstTree<T>>
}

implement Mappable

// 129. Breadth-first traversing in a graph
// Call a function f on every vertex accessible from vertex start, in breadth-first prefix order
type Vertex<T>{T, List<Integer>}
type BreadthFirstGraph<T>{Map<Integer, Vertex<T>>}

// 130. Depth-first traversing in a graph
// Call a function f on every vertex accessible for vertex v, in depth-first prefix order
type Vertex<T>{T, List<Integer>}
type DepthFirstGraph<T>{Map<Integer, Vertex<T>>}

// 131. Successive conditions
// Execute f1 if condition c1 is true, or else f2 if condition c2 is true, or else f3 if condition c3 is true.
// Don't evaluate a condition when a previous condition was true.


// 132. Measure duration of procedure execution
// Run procedure f, and return the duration of the execution of f.

// 133. Case-insensitive string contains
// Set boolean ok to true if string word is contained in string s as a substring, even if the case doesn't match, or to false otherwise.

// 134. Create a new list
// Declare and initialize a new list items, containing 3 elements a, b, c.

// 135. Remove item from list, by its value
// Remove at most 1 item from list items, having value x.
// This will alter the original list or return a new list, depending on which is more idiomatic.
// If there are several occurrences of x in items, remove only one of them. If x is absent, keep items unchanged.

// 136. Remove all occurrences of a value from a list
// Remove all occurrences of value x from list items.
// This will alter the original list or return a new list, depending on which is more idiomatic.

// 137. Check if string contains only digits
// Set boolean b to true if string s contains only characters in range '0'..'9', false otherwise.

// 138. Create temp file
// Create a new temporary file on filesystem.

// 139. Create temp directory
// Create a new temporary folder on filesystem, for writing.

// 140. Delete map entry
// Delete from map m the entry having key k.
// Explain what happens if k is not an existing key in m.

// 141. Iterate in sequence over two lists
// Iterate in sequence over the elements of the list items1 then items2. For each iteration print the element.

// 142. Hexadecimal digits of an integer
// Assign to string s the hexadecimal representation (base 16) of integer x.
// E.g. 999 -> "3e7"

// 143. Iterate alternatively over two lists
// Iterate alternatively over the elements of the list items1 and items2. For each iteration, print the element.
// Explain what happens if items1 and items2 have different size.

// 144. Check if file exists
// Set boolean b to true if file at path fp exists on filesystem; false otherwise.
// Beware that you should never do this and then in the next instruction assume the result is still valid, this is a race condition on any multitasking OS.

// 145. Print log line with datetime
// Print message msg, prepended by current date and time.
// Explain what behavior is idiomatic: to stdout or stderr, and what the date format is.

// 146. Convert string to floating point number
// Extract floating point value f from its string representation s

// 147. Remove all non-ASCII characters
// Create string t from string s, keeping only ASCII characters

// 150. Remove trailing slash
// Remove last character from string p, if this character is a slash /.

// 151. Remove string trailing path separator
// Remove last character from string p, if this character is the file path separator of current platform.
// Note that this also transforms unix root path "/" into the empty string!

// 152. Turn a character into a string
// Create string s containing only the character c.

// 153. Concatenate string with integer
// Create string t as the concatenation of string s and integer i.

// 154. Halfway between two hex color codes
// Find color c, the average between colors c1, c2.
// c, c1, c2 are strings of hex color codes: 7 chars, beginning with a number sign # .

// 155. Delete file
// Delete from filesystem the file having path filepath.

// 156. Format integer with zero-padding
// Assign to string s the value of integer i in 3 decimal digits. Pad with zeros if i < 100. Keep all digits if i ≥ 1000.

// 157. Declare constant string
// Initialize a constant planet with string value "Earth".

// 158. Random sublist
// Create a new list y from randomly picking exactly k elements from list x.
// It is assumed that x has at least k elements.
// Each element must have same probability to be picked.
// Each element from x must be picked at most once.
// Explain if the original ordering is preserved or not.

// 159. Trie
// Define a Trie data structure, where entries have an associated value.
// (Not all nodes are entries)

// 160. Detect if 32-bit or 64-bit architecture
// Execute f32() if platform is 32-bit, or f64() if platform is 64-bit.
// This can be either a compile-time condition (depending on target) or a runtime detection.

// 161. Multiply all the elements of a list
// Multiply all the elements of the list elements by a constant c

// 162. Execute procedures depending on options
// execute bat if b is a program option and fox if f is a program option.

// 163. Print list elements by group of 2
// Print all the list elements, two by two, assuming list length is even.

// 164. Open URL in default browser
// Open the URL s in the default browser.
// Set boolean b to indicate whether the operation was successful.

// 165. Last element of list
// Assign to variable x the last element of list items.

// 166. Concatenate two lists
// Create list ab containing all the elements of list a, followed by all elements of list b.

// 167. Trim prefix
// Create string t consisting of string s with its prefix p removed (if s starts with p).

// 168. Trim suffix
// Create string t consisting of string s with its suffix w removed (if s ends with w).

// 169. String length
// Assign to integer n the number of characters of string s.
// Make sure that multibyte characters are properly handled.
// n can be different from the number of bytes of s.

// 170. Get map size
// Set n to the number of elements stored in mymap.
// This is not always equal to the map capacity.

// 171. Add an element at the end of a list
// Append element x to the list s.

// 172. Insert entry in map
// Insert value v for key k in map m.

// 173. Format a number with grouped thousands
// Number will be formatted with a comma separator between every group of thousands.

// 174. Make HTTP POST request
// Make a HTTP request with method POST to URL u

// 175. Bytes to hex string
// From array a of n bytes, build the equivalent hex string s of 2n digits.
// Each byte (256 possible values) is encoded as two hexadecimal characters (16 possible values per digit).

// 176. Hex string to byte array
// From hex string s of 2n digits, build the equivalent array a of n bytes.
// Each pair of hexadecimal characters (16 possible values per digit) is decoded into one byte (256 possible values).

// 178. Check if point is inside rectangle
// Set boolean b to true if if the point with coordinates (x,y) is inside the rectangle with coordinates (x1,y1,x2,y2) , or to false otherwise.
// Describe if the edges are considered to be inside the rectangle.

// 179. Get center of a rectangle
// Return the center c of the rectangle with coördinates(x1,y1,x2,y2)

// 180. List files in directory
// Create list x containing the contents of directory d.
// x may contain files and subfolders.
// No recursive subfolder listing.

// 182. Quine program
// Output the source of the program.

// 184. Tomorrow
// Assign to variable t a string representing the day, month and year of the day after the current date.

// 185. Execute function in 30 seconds
// Schedule the execution of f(42) in 30 seconds.

// 186. Exit program cleanly
// Exit a program cleanly indicating no error to OS

// 189. Filter and transform list
// Produce a new list y containing the result of function T applied to all elements e of list x that match the predicate P.

// 190. Call an external C function
// Declare an external C function with the prototype

// void foo(double *a, int n);
// double a[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

// 191. Check if any value in a list is larger than a limit
// Given a one-dimensional array a, check if any value is larger than x, and execute the procedure f if that is the case

// 192. Declare a real variable with at least 20 digits
// Declare a real variable a with at least 20 digits; if the type does not exist, issue an error at compile time.

// 197. Get a list of lines from a file
// Retrieve the contents of file at path into a list of strings lines, in which each element is a line of the file.

// 198. Abort program execution with error condition
// Abort program execution with error condition x (where x is an integer value)

// 200. Return hypotenuse
// Returns the hypotenuse h of the triangle where the sides adjacent to the square angle have lengths x and y.

// 202. Sum of squares
// Calculate the sum of squares s of data, an array of floating point values.

// 205. Get an environment variable
// Read an environment variable with the name "FOO" and assign it to the string variable foo. If it does not exist or if the system does not support environment variables, assign a value of "none".

// 206. Switch statement with strings
// Execute different procedures foo, bar, baz and barfl if the string str contains the name of the respective procedure. Do it in a way natural to the language.

// 207. Allocate a list that is automatically deallocated
// Allocate a list a containing n elements (n assumed to be too large for a stack) that is automatically deallocated when the program exits the scope it is declared in.

// 208. Formula with arrays
// Given the arrays a,b,c,d of equal length and the scalar e, calculate a = e*(a+b*c+cos(d)).
// Store the results in a.

// 209. Type with automatic deep deallocation
// Declare a type t which contains a string s and an integer array n with variable size, and allocate a variable v of type t. Allocate v.s and v.n and set them to the values "Hello, world!" for s and [1,4,9,16,25], respectively. Deallocate v, automatically deallocating v.s and v.n (no memory leaks).

// 211. Create folder
// Create the folder at path on the filesystem

// 212. Check if folder exists
// Set boolean b to true if path exists on the filesystem and is a directory; false otherwise.

// 214. Pad string on the right
// Append extra character c at the end of string s to make sure its length is at least m.
// The length is the number of characters, not the number of bytes.

// 215. Pad string on the left
// Prepend extra character c at the beginning of string s to make sure its length is at least m.
// The length is the number of characters, not the number of bytes.

// 217. Create a Zip archive
// Create a zip-file with filename name and add the files listed in list to that zip-file.

// 218. List intersection
// Create list c containing all unique elements that are contained in both lists a and b.
// c should not contain any duplicates, even if a and b do.
// The order of c doesn't matter.

// 219. Replace multiple spaces with single space
// Create string t from the value of string s with each sequence of spaces replaced by a single space.
// Explain if only the space characters will be replaced, or the other whitespaces as well: tabs, newlines.

// 220. Create a tuple value
// Create t consisting of 3 values having different types.
// Explain if the elements of t are strongly typed or not.

// 221. Remove all non-digits characters
// Create string t from string s, keeping only digit characters 0, 1, 2, 3, 4, 5, 6, 7, 8, 9.

// 222. Find first index of an element in list
// Set i to the first index in list items at which the element x can be found, or -1 if items does not contain x.

// 223. for else loop
// Loop through list items checking a condition. Do something else if no matches are found.
// A typical use case is looping through a series of containers looking for one that matches a condition. If found, an item is inserted; otherwise, a new container is created.
// These are mostly used as an inner nested loop, and in a location where refactoring inner logic into a separate function reduces clarity.

// 224. Add element to the beginning of the list
// Insert element x at the beginning of list items.

// 225. Declare and use an optional argument
// Declare an optional integer argument x to procedure f, printing out "Present" and its value if it is present, "Not present" otherwise

// 226. Delete last element from list
// Remove the last element from list items.

// 227. Copy list
// Create new list y containing the same elements as list x.
// Subsequent modifications of y must not affect x (except for the contents referenced by the elements themselves if they contain pointers).

// 228. Copy a file
// Copy the file at path src to dst.

// 231. Test if bytes are a valid UTF-8 string
// Set b to true if the byte sequence s consists entirely of valid UTF-8 character code points, false otherwise.

// 234. Encode bytes to base64
// Assign to string s the standard base64 encoding of the byte array data, as specified by RFC 4648.

// 235. Decode base64
// Assign to byte array data the bytes represented by the base64 string s, as specified by RFC 4648.

// 237. Xor integers
// Assign to c the result of (a xor b)

// 238. Xor byte arrays
// Write in a new byte array c the xor result of byte arrays a and b.
// a and b have the same size.

// 239. Find first regular expression match
// Assign to string x the first word of string s consisting of exactly 3 digits, or the empty string if no such match exists.
// A word containing more digits, or 3 digits as a substring fragment, must not match.

// 240. Sort 2 lists together
// Lists a and b have the same length. Apply the same permutation to a and b to have them sorted based on the values of a.

// 241. Yield priority to other threads
// Explicitly decrease the priority of the current process, so that other execution threads have a better chance to execute now. Then resume normal execution and call function busywork.

// 242. Iterate over a set
// Call a function f on each element e of a set x.

// 243. Print list
// Print the contents of list a on the standard output.

// 244. 11
// 22

// 245. go
// df

// 246. Count distinct elements
// Set c to the number of distinct elements in list items.

// 247. Filter list in-place
// Remove all the elements from list x that don't satisfy the predicate p, without allocating a new list.
// Keep all the elements that do satisfy p.
// For languages that don't have mutable lists, refer to idiom #57 instead.

// 249. Declare and assign multiple variables
// Define variables a, b and c in a concise way.
// Explain if they need to have the same type.

// 251. Parse binary digits
// Extract integer value i from its binary string representation s (in radix 2)
// E.g. "1101" -> 13

// 252. Conditional assignment
// Assign to variable x the value "a" if calling the function condition returns true, or the value "b" otherwise.

// 258. Convert list of strings to list of integers
// Convert the string values from list a into a list of integers b.

// 259. Split on several separators
// Build list parts consisting of substrings of input string s, separated by any of the characters ',' (comma), '-' (dash), '_' (underscore).

