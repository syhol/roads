import ../../globals
import date
import amqp as amqp

type EventQueue = (
  connection: amqp.Connection
  channel: amqp.Channel
  boundQueues: Map<String, amqp.Queue> = Map()
  bindingQueues: Map<String, amqp.Queue> = Map()
)

exchangeName = "ad_event_queue"

publishEvent(queue: EventQueue, eventData: JSON) =>
  publishingEvent(eventData)
  minute = eventData->jsonGet("data.time")
    ->case
      JsonNumber(value) => value->Date
      Else => Date()
    ->setUTCSeconds(0)
    ->setUTCMilliseconds(0)
    ->getTime
  parentId = eventData->jsonGet("data.line_item")->case
    JsonString(value) => value
    Else => "0"
  q = "new.events.${minute}.${eventData.entity_type}.${eventData.id}.${parentId}"
  sendEvent(queue, "events", eventData)

// Refactor this to be less javascript like
setBindTimeout(queue: EventQueue, queueName: String) =>
  queue.boundQueues[queueName]->case (timeout: Timeout) => clearTimeout(timeout)
  queue.boundQueues[queueName] = setTimeout
    Seconds(65)
    () => queue.boundQueues->removeItem(queueName)

type ErrorSendingEvent = (queueName: String, eventData: JSON, error: Error)
type EventSent = (queueName: String)

sendEvent(queue: EventQueue, queueName: String, eventData: JSON) =>
  body = eventData->toString->toBuffer
  queue.channel->sendToQueue(queueName, body)->case
    Error(error) => ErrorSendingEvent(queueName, eventData, error)
    Else => EventSent(queueName)

connect(queueURI: String) =>
  connection = amqp.connectToBroker(queueURI)?
  channel = amqp.createChannel(connection)?
  amqp.assertExchange(channel, exchangeName, "topic", durable = false)?
  amqp.assertQueue(channel, "events", autoDelete = false)?
  EventQueue((channel, connection)

type getItem() => Number
type yieldItem(item: Number) =|

plusTen() =>
  (getItem() + 10)->yieldItem->plusTen

test "plusTen can reply and await events" =>
  plusTen = plusTen->bind(getItem() => 99)->spawn()
  plusTen->replyOnce(getItem() => 1)
  plusTen->waitFor(yieldItem).item->shouldEqual(11)
  plusTen->replyOnce(getItem() => 2)
  plusTen->waitFor(yieldItem).item->shouldEqual(12)
  plusTen->waitFor(yieldItem).item->shouldEqual(109)
  plusTen->waitFor(yieldItem).item->shouldEqual(109)

type getOpponent() => Data(Opponent(String) | NoOpponent)
type queueOpponent(String) =|

warrior(name: String) =>
  getOpponent()->case
    Opponent(opponent) => say("${name} beat ${opponent}")
    NoOpponent => queueOpponent(name)

main() =>
  battle: Queue(String) = Queue()
  battleRules = [
    getOpponent => battle->pop
    queueOpponent(name) => battle->push(name)
  ]

  ["Go", "C", "C++", "Java", "Perl", "Python"]
    ->map((language) => warrior->bind(battleRules)->spawn(language))
    ->awaitAll

test "The languages should battle as pairs" =>
  main = main()&
  main->waitFor(writeToStream).content->shouldEqual("Go beat C")
  main->waitFor(writeToStream).content->shouldEqual("C++ beat Java")
  main->waitFor(writeToStream).content->shouldEqual("Perl beat Python")

confirm(question: String) =>
  say("${question} (y/n)")
  stdin->readLine->toLowerCase->case
    ("y"|"yes") => True
    ("n"|"no") => False
    (Else) =>
      say("Please be clear: yes or no")
      confirm(question)

deleteStuff() =>
  confirm("Should I delete all your important files?")->case
    (True) => say("I'm sorry Dave, I'm afraid I can't do that.")
    (False) => say("I think you know what the problem is just as well as I do.")

test "delete stuff will keep asking until it gets a yes or no" =>
  deleteStuff = deleteStuff()&

  deleteStuff->waitFor(writeToStream).content
    ->shouldEqual("Should I delete all your important files? (y/n)")

  deleteStuff->replyOnce(readLineFromStream() => "test")
  deleteStuff->waitFor(writeToStream).content
    ->shouldEqual("Please be clear: yes or no")
  deleteStuff->waitFor(writeToStream).content
    ->shouldEqual("Should I delete all your important files? (y/n)")

  deleteStuff->replyOnce(readLineFromStream() => "yes")
  deleteStuff->waitFor(writeToStream).content
    ->shouldEqual("I'm sorry Dave, I'm afraid I can't do that.")

  deleteStuff->await

type toString<T>(T) => String

type User(firstName: String, lastName: String, age: Number)

toString<User>(user: User) =>
  "${user.firstName} ${user.lastName}, Age: ${user.age}"

say(...items: List(T)) where toString<T> =>
  items->map
    (item) => item->toString->writeToStream(stream = stdout)

test "can say what a user is" =>
  User("Simon", "Holloway", 26)->say&
    ->waitFor(writeToStream).content
    ->shouldEqual("I'm sorry Dave, I'm afraid I can't do that.")

logSomeStuff() =>
  doThings(123)&->listen
    writeToStream(content, stream) =>
      log.info("Writing to stream", (content, stream))


type AckPolicy = Data(AckNone | AckAll(wait: Number) | AckExplicit(wait: Number))
type StartPolicy = Data(
 | DeliverAll
 | DeliverLast
 | StartTime
 | StreamSeq
)
type ReplayPolicy = Data(ReplayInstant | ReplayOriginal)

type ConsumerConfig = Record(
  ackPolicy: AckPolicy
  startPolicy: StartPolicy
  deliverySubject: Optional(String)
  durable: String
  filterSubject: String
  maxDeliver: Number
  replayPolicy: ReplayPolicy
  sampleFrequency: Number
)

type InfoCollectionEvents =
  | GatheringInfo(Http.Request) =|
  | InfoGathered(count: Number) =|
  | MappingInfo() =|
  | InfoMapped() =|
  | ReducingInfo() =|
  | InfoReduced() =|

type Repository<T> =
  | create(record: T) => T
  | findOne(query: Partial<T>) => T
  | findMany(query: Partial<T>) => List<T>
  | delete(query: Partial<T>) => Number
  | update(query: Partial<T>, record: Partial<T>) => T
  | createMany(query: List<T>) => List<T>
  | updateMany(query: Partial<T>) => T


type getCoordinatesFromAddress(String) => (Number, Number)

storeService =
  getStoreCoordinates(store) =>
    getCoordinatesFromAddress(store->getAddress)

googleMapsAdapter =
  getCoordinatesFromAddress(address) =>
    googleMapsApi.makeRequest({
      apiKey = GOOGLE_API_KEY
      address = address
    })

openStreetMapAdapter =
  getCoordinatesFromAddress(address) =>
    openStreetMapApi.makeRequest({
      apiKey = OSM_API_KEY
      address = address
    })

storeService
  ->bind(googleMapsAdapter)
  .getStoreCoordinates(store)

openStreetMapAdapter
  ->bindTo(storeService)
  .getStoreCoordinates(store)

-- User Service

userService =
  getUsers() =>
    dbGetAll('users');

userService.getUsers()
