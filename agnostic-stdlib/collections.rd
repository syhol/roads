// Built in collections:
// - List - Eager Sequence
// - Generator - Lazy pull driven sequence
// - Observable - Lazy push driven sequence
// - Map - Key Value
// - MultiMap - Key Multiple Values
// - Set - Unique Collection
// - SortedSet - Unique Collection Sorted By An Integer. aka Priority Queue
// - String - Text

// 3rd party collections:
// - Deque
// - Stack
// - Queue
// - FixedSizeList
// - Tree
// - BinaryTree
// - Graph

// Collection constructors
interface CastToList<T>
  toList<E>(T<E>) => List<E>

interface CastToSet<T>
  toSet<E>(T<E>) => Set<E>

interface CastToGenerator<T>
  toGenerator<E>(T<E>) => Generator<E>

iterate<T>(T, T => T) => Generator<T>
repeat<T>(T) => Generator<T>
cycle<T: SyncronousSequence, E>(T<E>) => Generator<E>
range<T: Number>(T, T) => Generator<T>
[1, 2, 3, 4]

--- Sequences

interface Sequence<T>
  tail<E>(T<E>) => T<E>
  init<E>(T<E>) => T<E>
  take<E>(T<E>, Integer) => T<E>
  takeLast<E>(T<E>, Integer) => T<E>
  skip<E>(T<E>, Integer) => T<E>
  skipLast<E>(T<E>, Integer) => T<E>
  indexed<E>(T<E>) => T<{Integer, E}>
  slice<E>(T<E>, Integer, Integer) => T<E>
  withoutPrefix<E>(T<E>, T<E>) => T<E>
  withoutSuffix<E>(T<E>, T<E>) => T<E>
  chunksOf<E>(T<E>, Integer) => T<List<E>>
  windowsOf<E>(T<E>, Integer) => T<List<E>>

interface SyncronousSequence<T: Sequence>
  next<E>(T<E>) => Optional<{E, T<E>}>
  end<E>(T<E>) => Optional<{E, T<E>}>
  first<E>(T<E>) => Optional<E>
  last<E>(T<E>) => Optional<E>
  elementAt<E>(T<E>, Integer) => Optional<E>
  startsWith<E>(T<E>, Sequence<E>) => Boolean
  endsWith<E>(T<E>, Sequence<E>) => Boolean
  indexOf<E: Eq>(T<E>, E) => Optional<Integer>
  indexOfSequence<E: Eq>(T<E>, T<E>) => Optional<Integer>
  lastIndexOf<E: Eq>(T<E>, E) => Optional<Integer>
  lastIndexOfSequence<E: Eq>(T<E>, T<E>) => Optional<Integer>
  indicesOf<E: Eq>(T<E>, E) => List<Integer>
  indicesOfSequence<E: Eq>(T<E>, T<E>) => List<Integer>

interface AsyncronousSequence<T: Sequence>
  resolveSequence<E, R>(T<E>, List<E> => R) => Promise<R>

Generator implements Sequence SyncronousSequence
Observable implements Sequence AsyncronousSequence
List implements Sequence SyncronousSequence
String implements Sequence SyncronousSequence
//!! Problem - String has a kind of * where Sequence needs * -> *

--- Monads

interface Emptiable<T>
  isEmpty(T) => Boolean
  makeEmpty() => T

interface Concatenatable<T: Emptiable>
  concat(T, T) => T

interface Mappable<T>
  map<A, B>(T<A>, A => B) => T<B>
  each<E>(T<E>, E => Discard) => T<E>

interface Expandable<T: Mappable & Concatenatable>
  filter<E>(T<E>, E => Boolean) => T<E>
  flatMap<A, B>(T<A>, A => T<B>) => T<B>

Generator implements Concatenatable Mappable Expandable
List implements Concatenatable Mappable Expandable
Set implements Concatenatable Mappable Expandable
String implements Concatenatable
Map implements Concatenatable

--- Scanable types

interface Scanable<T>
  scan<A, B>(T<A>, (B, A) => B) => T<B>
  scanRight<A, B>(T<A>, (A, B) => B) => T<B>

--- Foldable types

interface Countable<T>
  count(T) => Integer

interface Membership<T>
  contains<E: Eq>(T<E>, E) => Boolean
  containsSequence<E: Eq, Q: Sequence<E>>(T<E>, Q) => Boolean // ~!!!
  containsAll<E: Eq, Q: Foldable<E>>(T<E>, Q) => Boolean
  containsAny<E: Eq, Q: Foldable<E>>(T<E>, Q) => Boolean
  containsAllSequences<E: Eq, Q: Foldable<Sequence<E>>>(T<E>, Q) => Boolean
  containsAnySequence<E: Eq, Q: Foldable<Sequence<E>>>(T<E>, Q) => Boolean

interface Foldable<T: CastToList & Countable & Emptiable & Membership>
  reduce<A, B>(T<A>, (B, A) => B) => Optional<B>
  reduceRight<A, B>(T<A>, (A, B) => B) => Optional<B>
  fold<A, B>(T<A>, B, (B, A) => B) => B
  foldRight<A, B>(T<A>, B, (A, B) => B) => B
  find<E>(T<E>, E => Boolean) => Optional<E>
  findLast<E>(T<E>, E => Boolean) => Optional<E>
  any<E>(T<E>, E => Boolean) => Boolean
  all<E>(T<E>, E => Boolean) => Boolean
  maximum<E: Ordinal>(T<E>) => E
  minimum<E: Ordinal>(T<E>) => E
  sum<E: Number>(T<E>) => E
  product<E: Number>(T<E>) => E
  flat<E: Concatenatable>(T<E>) => E
  single<E>(T<E>) => Optional<E>

implement Countable for Foldable
  count(countable) => countable->fold(0, (count, item) => count + 1)

implement Countable for String
  count(countable) => countable->getCharacters->count

Generator implements Countable Emptiable Membership Foldable
List implements Countable Emptiable Membership Foldable
Set implements Countable Emptiable Membership Foldable
String implements Countable Emptiable
Map implements Countable Emptiable

--- Sort

interface Sortable<T>
  sort<E>(T<E>, (E, E) => Integer) => T<E>
  reverse(T) => T
  shuffle(T, seed: Integer) => T

--- 

interface Sink<T>
  add<E>(T<E>, E) => T<E>

--

TBD:
  append ??
  prepend ??
  intersperse
  intercalate (aka join)
  transpose
  subsequences
  permutations
  splitAt
  span?
  break?
  partition

type StateRequest<T> = UpdateState{T => T} | GetState
type CurrentState<T>{T}
type State<T> = Coroutine<StateRequest<T>, CurrentResponse<T>, Never>

makeState<T>(value: T): State<T> =>
  spawn (value) =>
    receive
      SetState{newValue} => self(newValue)
      GetState =>
        #CurrentState{value}
        self(value)

getState<T>(state: State<T>): T =>
  state
    ->send(GetState)
    ->receive CurrentState{value} => value

setState<T>(state: State<T>, update: T => T): {} => state->send(SetState{value})

type Generator<T>{
  realised: State<List<T>>
  done: Boolean
  next() => Optional<T>
}