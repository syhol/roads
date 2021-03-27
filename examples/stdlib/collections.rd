
// Generators
iterate<T>(T, T => T) => Generator<T>
repeat<T>(T) => Generator<T>
cycle<T, E>(T<E>) => Generator<E>

interface Listable<T>
  toList<E>(T<E>) => List<E>

interface IndexedSequence<T: Sequence>
  elementAt<E>(T<E>, Integer) => Optional<E>
  subSequence<E>(T<E>, Sequence<Integer>) => T

// Maybe infinite, sequentially ordered collection
interface Sequence<T: Listable>
  head<E>(T<E>) => Optional<E>
  tail<E>(T<E>) => T<E>
  next<E>(T<E>) => Optional<{E, T<E>}>
  take<E>(T<E>, Integer) => T<E>
  takeWhile<E>(T<E>, E => Boolean) => T<E>
  skip<E>(T, Integer) => T
  skipWhile<E>(T<E>, E => Boolean) => T<E>

// Finite, sequentially ordered collection
interface Collection<T: Sequence>
  last<E>(T<E>) => Optional<E>
  init<E>(T<E>) => T<E>
  skipLast<E>(T<E>, Integer) => T<E>
  skipLastWhile<E>(T<E>, E => Boolean) => T<E>
  takeLast<E>(T<E>, Integer) => T<E>
  takeLastWhile<E>(T<E>, E => Boolean) => T<E>

Eager collection - List - Implements Collection
Lazy collection - Generator e.g. Range - Implements Sequence

implement Sequence for Generator
implement IndexedSequence for Generator
implement Sequence for List
implement IndexedSequence for List
implement Collection for List
---

interface Countable<T>
  count(T) => Integer

interface Emptiable<T>
  isEmpty(T) => Boolean
  empty() => T

interface Concatenatable<T>
  concat(T, T) => T

interface Mappable<T>
  map<A, B>(T<A>, A => B) => T<B>
  each<E>(T<E>, E => discard) => T<E>

interface Expandable<T: Mappable & Concatenatable & Emptiable>
  expand<A, B>(T<A>, A => T<A>) => T<B>
  filter<E>(T<E>, E => Boolean) => T<E>

interface Membership<T>
  contains<E: Eq>(T<E>, E) => Boolean
  containsAll<E: Eq, Q: Foldable<E>>(T<E>, Q) => Boolean
  containsAny<E: Eq, Q: Foldable<E>>(T<E>, Q) => Boolean

interface Foldable<T: Emptiable & Countable & Listable & Membership>
  reduce<A, B>(T<A>, (B, A) => B) => Optional<B>
  reduceRight<A, B>(T<A>, (A, B) => B) => Optional<B>
  fold<A, B>(T<A>, B, (B, A) => B) => B
  foldRight<A, B>(T<A>, B, (A, B) => B) => B
  find<E>(T<E>, E => Boolean) => Optional<E>
  any<E>(T<E>, E => Boolean) => Boolean
  all<E>(T<E>, E => Boolean) => Boolean
  maximum<E: Ordinal>(T<E>) => E
  minimum<E: Ordinal>(T<E>) => E
  sum<E: Number>(T<E>) => E
  product<E: Number>(T<E>) => E
  flat<E: Concatenatable>(T<E>) => E

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