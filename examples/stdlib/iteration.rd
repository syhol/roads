
concat
append
prepend
head
last
tail
init
map
reverse
subsequences
permutations
foldLeft
foldRight
reduceLeft
reduceRight

any
all

sum
product
max
min

scanLeft
scanRight

iterate
repeat<T>: (item: T) => Iterable
cycle

dropFirst
dropFirstWhile
dropLast
dropLastWhile
takeFirst
takeFirstWhile
takeLast
takeLastWhile
splitAt

span?
break?

Iterable - A collection of values, or "elements", that can be accessed.
Eager iterable - List
Lazy iterable - Generator

interface Iterable<I<T, Z = None>>
  getIterator(iterable: I) => Iterator<T, Z>

Iterator:
data CollectionItem<T, Z> = Next(item: T) | End(result: Z)

interface Iterator<T, Z>
  next() => IteratorNext<T, Z>

type InfiniteIterable<T> = Iterator<T, None>

---

implement Iterable<I<T, Z>> where Iterator<I, T, Z>
  getIterator(iterable: I) => iterable

implement Iterable<List<T>> where List<T>
  getIterator(iterable: I) => iterable
