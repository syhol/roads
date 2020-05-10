import ../../globals
import amqp
require postgres
require logger
require https://github.com/antirez/redis/archive/5.0.9.zip as redis

enum EventQueue
  connection: amqp.Connection
  channel: amqp.Channel
  boundQueues: Map<String, amqp.Queue> = Map()
  bindingQueues: Map<String, amqp.Queue> = Map()

exchangeName = "ad_event_queue"

publishEvent(queue: EventQueue, eventData: JSON) =>
  #PublishingEvent(eventData)
  minute = eventData->jsonGet("data.time")
    ->case
      JsonString(value) => value->dateFromString
      JsonNumber(value) => value->dateFromUnixSeconds
      Else => Date()
    ->withUTCSeconds(0)
    ->withUTCMilliseconds(0)
    ->inUnixSeconds
  parentId = eventData->jsonGet("data.line_item")->case
    JsonString(value) => value
    Else => "0"
  q = "new.events.${minute}.${eventData.entity_type}.${eventData.id}.${parentId}"
  sendEvent(queue, "events", eventData)

sleepFor(duration: Duration) =>
  #SetTimeout(duration)
  receive->case(#Timeout => ())

setBindTimeout(queue: EventQueue, queueName: String) =>
  queue.boundQueues[queueName]->case (fiber: Fiber) => destroyFiber(fiber)
  queue.boundQueues[queueName] = spawn () =>
    sleepFor(65->Seconds)
    queue.boundQueues->removeItem(queueName)

enum ErrorSendingEvent(queueName: String, eventData: JSON, error: Error)
enum EventSent(queueName: String)

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


plusTen() =>
  receive->case #GiveItem(number: Number) => #YieldItem(number + 10)
  plusTen()

test "plusTen can reply and await events" =>
  plusTen()
    -->isTypeOf(Coroutine<Number, Number>)
    -->send(#!GiveItem(1))
    -->shouldProduce(#!YieldItem(11))
    -->send(#!GiveItem(2))
    -->shouldProduce(#!YieldItem(12))
    -->send(#!GiveItem(99))
    -->shouldProduce(#!YieldItem(109))
    -->send(#!GiveItem(99))
    -->shouldProduce(#!YieldItem(109))

warrior(name: String) =>
  receive->case
    #Opponent(opponent: String) => say("${name} beat ${opponent}")
    #NoOpponent => #QueueOpponent(name)

battle() =>
  receive->case
    #QueueOpponent(name: String) => #Opponent(name)
  battle()

battleOfLanguages() =>
  battleBuffer = battle()&
  ["Go", "C", "C++", "Java", "Perl", "Python"]
    ->map((language) => battleBuffer | warrior(language)& | battleBuffer)

test "The languages should battle as pairs" =>
  battleOfLanguages()&
    -->shouldProduce(#!Say("Go beat C"))
    -->shouldProduce(#!Say("C++ beat Java"))
    -->shouldProduce(#!Say("Perl beat Python"))

listener(name: String) => receive->case #Say(message) => say("${name}: ${message}")

fanIn() =>
  listener("listener 1")&
    -->consume(say("Hey 1")&)
    -->consume(say("Hey 2")&)
    -->consume(say("Hey 3")&)

multicast() =>
  say("Hey 1")&
    -->pipe(listener("listener 1")&)
    -->pipe(listener("listener 2")&)
    -->pipe(listener("listener 3")&)

queueGroup() =>
  say("Hey 1")&->createQueueGroup
    -->pipe(listener("listener 1")&)
    -->pipe(listener("listener 2")&)
    -->pipe(listener("listener 3")&)

reqRepRequester(value: Number) =>
  #Request(value, this)
  receive->case #Reply(newValue) => say("I got ${newValue}")

reqRepReplyer() =>
  receive->case #Request(value: Number, return: Coroutine<#Reply(Number), Any>) => return->send(#!Reply(value + 5))

requestReply() =>
  example = spawn () =>
    reqRepRequester(10)
    reqRepRequester(20)
    reqRepRequester(30)
  example
    -->pipe(reqRepReplyer())
    -->shouldProduce(#!Say("I got 15"))
    -->shouldProduce(#!Say("I got 25"))
    -->shouldProduce(#!Say("I got 35"))

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
  deleteStuff()&
    -->shouldProduce(#!Say(("Should I delete all your important files? (y/n)")
    -->send(#!ReadLine("test"))
    -->shouldProduce(#!Say(("Please be clear: yes or no")
    -->shouldProduce(#!Say(("Should I delete all your important files? (y/n)")
    -->send(#!ReadLine("YES"))
    -->shouldProduce(#!Say(("I'm sorry Dave, I'm afraid I can't do that.")

interface Stringable<T>
  toString(T) => String

enum User(firstName: String, lastName: String, age: Number)

implement Stringable<User>
  toString(User(firstName, lastName, age)) => "${firstName} ${lastName}, Age: ${age}"

say(...items: List<T>) where Stringable<T> =>
  items->map
    (item) => item->toString->writeToStream(stream = stdout)

test "can say what a user is" =>
  User("Simon", "Holloway", 26)->say&
    -->shouldProduce(#!WriteToStream("Simon Holloway, Age: 26", stdin))

logSomeStuff() =>
  doThings(123)&->listen
    writeToStream(content, stream) =>
      log.info("Writing to stream", (content, stream))


AckPolicy = enum AckNone | AckAll(wait: Number) | AckExplicit(wait: Number)
StartPolicy = enum
 | DeliverAll
 | DeliverLast
 | StartTime
 | StreamSeq

ReplayPolicy = enum ReplayInstant | ReplayOriginal

enum ConsumerConfig
  ackPolicy: AckPolicy
  startPolicy: StartPolicy
  deliverySubject: Optional(String)
  durable: String
  filterSubject: String
  maxDeliver: Number
  replayPolicy: ReplayPolicy
  sampleFrequency: Number

message GatheringInfo(request: Http.Request)
message InfoGathered(count: Number)
message MappingInfo
message InfoMapped
message ReducingInfo
message InfoReduced

interface Repository<T>
  create(record: T) => T
  findOne(query: Partial<T>): T = findMany(query)->elementAt(0)
  findMany(query: Partial<T>) => List<T>
  delete(query: Partial<T>) => Number
  update(query: Partial<T>, record: Partial<T>) => T
  createMany(records: List<T>) => List<T>
  updateMany(query: Partial<T>, record: Partial<T>) => T

pgUsers = postgres->table("users")

implement Repository<User> =
  create(record) => pgUsers()->insert(record)
  findMany(query) => pgUsers()->findMany(query)
  delete(query) => pgUsers()->delete(query)
  update(query, record) => pgUsers()->update(query, record)
  createMany(records) => pgUsers()->createMany(records)
  updateMany(query, records) => pgUsers()->updateMany(query, records)

userFromHttpRequest(request: http.Request): User =>
  jsonBody = request.body->toJson
  firstName = jsonBody->getOrError("data.first_name")?
  lastName = jsonBody->getOrError("data.last_name")?
  age = jsonBody->getOrError("data.age")?
  User(firstName, lastName, age)

httpPostUser(request: http.Request) => request->userFromHttpRequest->case
  Ok(user) => create(user)

-- With DI

getCoordinatesFromAddress = alias (String) => (Number, Number)

storeService(mapAdapter) => record
  getStoreCoordinates(store) =>
    mapAdapter.getCoordinatesFromAddress(store->getAddress)

googleMapsAdapter =
  getCoordinatesFromAddress(address) =>
    googleMapsApi.makeRequest(
      apiKey = GOOGLE_API_KEY
      address = address
    )

openStreetMapAdapter =
  getCoordinatesFromAddress(address) =>
    openStreetMapApi.makeRequest(
      apiKey = OSM_API_KEY
      address = address
    )

storeService(googleMapsAdapter)
  .getStoreCoordinates(store)

storeService(openStreetMapAdapter)
  .getStoreCoordinates(store)

-- With Coroutines

getStoreCoordinates(store) =>
  #GetCoordinatesFromAddress(store->getAddress)
  receive->case(#CoordinatesFromAddress(coordinates) => coordinates)

googleMapsAdapter() =>
  receive->case (request: #GetCoordinatesFromAddress) =>
    googleMapsApi.makeRequest(
      apiKey = GOOGLE_API_KEY
      address = request.address
    )->send(to = request.sender)
  googleMapsAdapter()

openStreetMapAdapter() =>
  receive->case (request: #GetCoordinatesFromAddress) =>
    openStreetMapApi.makeRequest(
      apiKey = OSM_API_KEY
      address = request.address
    )->send(to = request.sender)
  openStreetMapAdapter()

getStoreCoordinates(store)&
  -->pipe(googleMapsAdapter()&)
  ->await

getStoreCoordinates(store)&
  -->pipe(openStreetMapAdapter()&)
  ->await

enum HttpHeader(String, String)
HttpVerb = enum GET | POST | PATCH | PUT | DELETE
enum HttpRequest(HttpVerb, Uri, List<HttpHeader>, Stream<List<Bytes>>)
enum HttpResponse(Integer, List<HttpHeader>, Stream<List<Bytes>>)
message SendHttpRequest(HttpRequest)
message ReceiveHttpResponse(HttpResponse)

makeHttpRequest(verb: HttpVerb, url: String) =>
  HttpRequest(verb, url, [], toByteStream(""))

sendHttpRequest(request: HttpRequest) =>
  #SendHttpRequest(request)
  receive->case
    #ReceiveHttpResponse(response) => response

request(verb: HttpVerb, url: String): Coroutine<ReceiveHttpResponse, SendHttpRequest, HttpResponse> =>
  makeHttpRequest(verb, url)->sendHttpRequest()&-->bubble()

R1 = request(GET, ‘https://example.com/1’)
R2 = request(GET, ‘https://example.com/1’)
R3 = request(GET, ‘https://example.com/1’)
awaitAll(R1, R2, R3)
