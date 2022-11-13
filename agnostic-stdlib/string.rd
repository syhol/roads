Checks:

ASCII
control: String
space: String
whitespace: String // space + control
digit: String
symbol: String
lowerCase: String
upperCase: String
alpha: String // upperCase + lowerCase
alphaNumeric: String // upperCase + lowerCase + digit
printable: String // upperCase + lowerCase + digit + symbol + space

isControl: (String) => Boolean
isSpace: (String) => Boolean
isWhitespace: (String) => Boolean
isDigit: (String) => Boolean
isSymbol: (String) => Boolean
isLowerCase: (String) => Boolean
isUpperCase: (String) => Boolean
isAlpha: (String) => Boolean
isAlphaNumeric: (String) => Boolean
isPrintable: (String) => Boolean

Finding Substrings:
startsWith // Collections
endsWith // Collections
containsSequence // Collections
indexOf // Collections
lastIndexOf // Collections
allIndicesOf // Collections
count // Collections

Convert:
toLowerCase
toUpperCase
capitalize
normalize

Iterators:
split
lines
words
characters

Creating Substrings:
take // Collections
takeLast // Collections
skip // Collections
skipLast // Collections
substring // Collections

Sorting:
shuffle
reverse
sort

Misc:
pad
padLeft
padRight
trim
trimLeft
trimRight
withoutPrefix // Collections
withoutSuffix // Collections
replaceFirst
replaceLast
replaceAll
replaceRange#

Very Misc:
join
repeat
first
last
lastIndex