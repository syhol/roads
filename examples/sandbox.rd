#!/usr/local/bin roads-alpha --exe --syntax indent

import ../../globals
import amqpFactory
import type amqp
require postgres as pg
require logger
require https://github.com/antirez/redis/archive/5.0.9.zip as redis
require getNow as time

type getNow() => Integer

data EventQueue
  connection: AMQPConnection
  channel: AMQPChannel
  boundQueues: Map<String, AMQPQueue> = Map()
  bindingQueues: Map<String, AMQPQueue> = Map()

exchangeName = "ad_event_queue"

data PublishingEvent(JSON)

publishEvent(queue: EventQueue, eventData: JSON) =>
  #PublishingEvent(eventData)
  minute = eventData->jsonGet("data.time")
    ->case
      JsonString(value) => value->dateFromString
      JsonNumber(value) => value->dateFromUnixSeconds
      Else => time()->dateFromUnixSeconds
    ->withUTCSeconds(0)
    ->withUTCMilliseconds(0)
    ->inUnixSeconds
  parentId = eventData->jsonGet("data.line_item")->case
    JsonString(value) => value
    Else => "0"
  q = "new.events.${minute}.${eventData.entity_type}.${eventData.id}.${parentId}"
  sendEvent(queue, "events", eventData)

data SetTimeout(Duration, Sink<Timeout>)
data Timeout
data Cancel

setBindTimeout(queue: EventQueue, queueName: String) =>
  queue.boundQueues[queueName]->case
    (job: Sink<Cancel>) => job->send(Cancel())
  queue.boundQueues[queueName] = spawn () =>
    #SetTimeout(65->Seconds, this)
    receive
      Timeout => queue.boundQueues->removeItem(queueName)
      Cancel => ()

data ErrorSendingEvent(queueName: String, eventData: JSON, error: Error)
data EventSent(queueName: String)

sendEvent(queue: EventQueue, queueName: String, eventData: JSON) =>
  body = eventData->toString->toBuffer
  queue.channel->sendToQueue(queueName, body)->case
    (error: Error) => ErrorSendingEvent(queueName, eventData, error)
    Else => EventSent(queueName)

connect(queueURI: String) =>
  connection = connectToBroker(queueURI)?
  channel = createChannel(connection)?
  assertExchange(channel, exchangeName, "topic", durable = false)?
  assertQueue(channel, "events", autoDelete = false)?
  EventQueue(channel, connection)

data GiveItem(Number)
data YieldItem(Number)

plusTen() =>
  receive GiveItem(number: Number) => #YieldItem(number + 10)
  plusTen()

test "plusTen can reply and await events" =>
  plusTen()&
    -->isTypeOf(Coroutine<GiveItem, YieldItem, Never>)
    -->send(GiveItem(1))
    -->shouldProduce(YieldItem(11))
    -->send(GiveItem(2))
    -->shouldProduce(YieldItem(12))
    -->send(GiveItem(99))
    -->shouldProduce(YieldItem(109))
    -->send(GiveItem(99))
    -->shouldProduce(YieldItem(109))

warrior(name: String) =>
  receive
    Opponent(opponent: String) => say("${name} beat ${opponent}")
    NoOpponent => #QueueOpponent(name)

battle() =>
  receive
    QueueOpponent(name: String) => #Opponent(name)
  battle()

battleOfLanguages() =>
  battleBuffer = battle()&
  ["Go", "C", "C++", "Java", "Perl", "Python"]
    ->map (language) =>
      battleBuffer | warrior(language)&^ | battleBuffer

test "The languages should battle as pairs" =>
  battleOfLanguages()&
    -->shouldProduce(Say("Go beat C"))
    -->shouldProduce(Say("C++ beat Java"))
    -->shouldProduce(Say("Perl beat Python"))

listener(name: String) => receive Say(data) => say("${name}: ${data}")

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

data RRReply(Number)
data RRRequest(Number, Sink<RRReply>)

reqRepRequester(value: Number) =>
  #RRRequest(value, this)
  receive RRReply(newValue) => say("I got ${newValue}")

reqRepReplyer() =>
  receive RRRequest(value, reply) => reply->send(RRReply(value + 5))

requestReply() =>
  example = spawn () =>
    reqRepRequester(10)
    reqRepRequester(20)
    reqRepRequester(30)
  example
    -->pipe(reqRepReplyer()&)
    -->shouldProduce(Say("I got 15"))
    -->shouldProduce(Say("I got 25"))
    -->shouldProduce(Say("I got 35"))

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
    -->shouldProduce(Say("Should I delete all your important files? (y/n)"))
    -->send(ReadLine("test"))
    -->shouldProduce(Say("Please be clear: yes or no"))
    -->shouldProduce(Say("Should I delete all your important files? (y/n)"))
    -->send(ReadLine("YES"))
    -->shouldProduce(Say("I'm sorry Dave, I'm afraid I can't do that."))

interface Stringable<T>
  toString(T) => String

data User(firstName: String, lastName: String, age: Number)

implement Stringable<User>
  toString(User(firstName, lastName, age)) => "${firstName} ${lastName}, Age: ${age}"

data Say(T) where Stringable<T>

say(...items: List<T>) where Stringable<T> =>
  items->map
    (item) => item->toString->#Say

test "can say what a user is" =>
  User("Simon", "Holloway", 26)->say&
    -->shouldProduce(Say("Simon Holloway, Age: 26"))

logSomeStuff() =>
  doThings(123)&->listen
    Say(content) =>
      log.info("Writing to output: #{content}")


AckPolicy = data AckNone | AckAll(wait: Number) | AckExplicit(wait: Number)
StartPolicy = data
 | DeliverAll
 | DeliverLast
 | StartTime
 | StreamSeq

ReplayPolicy = data ReplayInstant | ReplayOriginal

data ConsumerConfig
  ackPolicy: AckPolicy
  startPolicy: StartPolicy
  deliverySubject: Optional(String)
  durable: String
  filterSubject: String
  maxDeliver: Number
  replayPolicy: ReplayPolicy
  sampleFrequency: Number

InfoEvents = data
 | GatheringInfo(request: Http.Request)
 | InfoGathered(count: Number)
 | MappingInfo
 | InfoMapped
 | ReducingInfo
 | InfoReduced

interface Repository<T>
  create(record: T) => T
  findOne(query: Partial<T>): T = findMany(query)->elementAt(0)
  findMany(query: Partial<T>) => List<T>
  delete(query: Partial<T>) => Number
  update(query: Partial<T>, record: Partial<T>) => T
  createMany(records: List<T>) => List<T>
  updateMany(query: Partial<T>, record: Partial<T>) => T

pgUsers() = pg->table("users")

implement Repository for User =
  create(record) => pgUsers()->insert(record)
  findMany(query) => pgUsers()->findMany(query)
  delete(query) => pgUsers()->delete(query)
  update(query, record) => pgUsers()->update(query, record)
  createMany(records) => pgUsers()->createMany(records)
  updateMany(query, records) => pgUsers()->updateMany(query, records)

userFromHttpRequest(request: http.Request): User =>
  jsonBody = request.body->toJson
  firstName = jsonBody->getStringOrError("data.first_name")?
  lastName = jsonBody->getStringOrError("data.last_name")?
  age = jsonBody->getIntegerOrError("data.age")?
  User(firstName, lastName, age)

httpPostUser(request: http.Request) =>
  request->userFromHttpRequest?->create

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

data GetCoordinatesFromAddress(address: String, reply: Sink<Coordinates>)
data Coordinates(Number, Number)

getStoreCoordinates(store) =>
  #GetCoordinatesFromAddress(store->getAddress, this)
  receive (coordinates: Coordinates) => coordinates

googleMapsAdapter() =>
  receive (request: GetCoordinatesFromAddress) =>
    googleMapsApi.makeRequest(
      apiKey = GOOGLE_API_KEY
      address = request.address
    )->Coordinates->send(to = request.reply)
  googleMapsAdapter()

openStreetMapAdapter() =>
  receive (request: GetCoordinatesFromAddress) =>
    openStreetMapApi.makeRequest(
      apiKey = OSM_API_KEY
      address = request.address
    )->Coordinates->send(to = request.reply)
  openStreetMapAdapter()

getStoreCoordinates(store)&
  -->pipe(googleMapsAdapter()&)
  ->await

getStoreCoordinates(store)&
  -->pipe(openStreetMapAdapter()&)
  ->await

data HttpHeader(String, String)
HttpVerb = data GET | POST | PATCH | PUT | DELETE
data HttpRequest(HttpVerb, Uri, List<HttpHeader>, Stream<List<Bytes>>)
data HttpResponse(Integer, List<HttpHeader>, Stream<List<Bytes>>)

makeHttpRequest(verb: HttpVerb, url: String) =>
  HttpRequest(verb, url, [], toByteStream(""))

sendHttpRequest(request: HttpRequest) =>
  #request
  receive
    (response: HttpResponse) => response

request(verb: HttpVerb, url: String): Coroutine<HttpResponse, HttpRequest, HttpResponse> =>
  makeHttpRequest(verb, url)->sendHttpRequest()&^

R1 = request(GET, "https://example.com/1")
R2 = request(GET, "https://example.com/1")
R3 = request(GET, "https://example.com/1")
awaitAll(R1, R2, R3)

--start

--data

--public

--private

--test

