
// Generators
iterate<T>(init: T, generator: ((T) => T)) => Generator<T>
repeat<T>(item: T) => Generator<T>
cycle<T, E>(items: T<E>) => Generator<E>

interface Listable<T>
  toList(T) => List

interface IndexedSequence<T: Sequence>
  elementAt<E>(T<E>, Integer) => Optional<E>
  subSequence<E>(T<E>, Sequence<Integer>) => T

// Maybe infinite, sequentially ordered collection
interface Sequence<T: Listable>
  head<E>(T<E>) => Optional<E>
  tail(T) => T
  next<E>(T<E>) => Optional<{E, T<E>}>
  take(T, Integer) => T
  takeWhile(T, ((T) => Boolean)) => T
  skip(T, Integer) => T
  skipWhile(T, ((T) => Boolean)) => T

// Finite, sequentially ordered collection
interface Collection<T: Sequence>
  last<E>(T<E>) => Optional<E>
  init(T) => T
  skipLast(T, Integer) => T
  skipLastWhile(T, ((T) => Boolean)) => T
  takeLast(T, Integer) => T
  takeLastWhile(T, ((T) => Boolean)) => T

Eager collection - List - Implements Collection
Lazy collection - Generator e.g. Range - Implements Sequence

implement Sequence for Generator
implement IndexedSequence for Generator
implement Sequence for List
implement IndexedSequence for List
implement Collection for List
---

interface Countable<T>
  count(countable: T) => Integer

interface Emptiable<T>
  isEmpty(T) => Boolean
  empty() => T

interface Concatenatable<T>
  concat(T, T) => T

interface Mappable<T>
  map<A, B>(mappable: T<A>, (item: A) => B) => T<B>
  each<E>(mappable: T<E>, (item: E) => {}) => T<E>

interface Expandable<T: Mappable & Concatenatable & Emptiable>
  expand<A, B>(mappable: T<A>, (item: A) => T<A>) => T<B>
  filter<E>(mappable: T<E>, (item: E) => Boolean) => T<E>

interface Membership<T, E: Eq>
  contains(haystack: T<E>, needle: E) => Boolean
  containsAll<Q: Foldable<E>>(haystack: T<E>, needles: Q) => Boolean

interface Foldable<T: Emptiable & Countable & Listable & Membership>
  reduce<A, B>(foldable: T<A>, reducer: (acc: B, next: A) => B) => Optional<B>
  reduceRight<A, B>(foldable: T<A>, reducer: (next: A, acc: B) => B) => Optional<B>
  fold<A, B>(foldable: T<A>, initial: B, reducer: (acc: B, next: A) => B) => B
  foldRight<A, B>(foldable: T<A>, initial: B, reducer: (next: A, acc: B) => B) => B
  find<E>(foldable: T<E>, check: (next: E) => Boolean) => Optional<E>
  any<E>(foldable: T<E>, check: (next: E) => Boolean) => Boolean
  all<E>(foldable: T<E>, check: (next: E) => Boolean) => Boolean
  maximum<E: Ordinal>(foldable: T<E>) => E
  minimum<E: Ordinal>(foldable: T<E>) => E
  sum<E: Number>(foldable: T<E>) => E
  product<E: Number>(foldable: T<E>) => E

implement Countable for Foldable
  count(countable) => countable->fold(0, (count, item) => count + 1)

implement Countable for String
  count(countable) => countable->getCharacters->count

TBD:
  append ??
  prepend ??
  intersperse
  intercalate (aka join)
  transpose
  subsequences
  permutations
  reverse
  splitAt
  span?
  break?
  partition

  scanLeft
  scanRight