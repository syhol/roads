#!/usr/local/bin roads-alpha --exe --syntax indent

// Import values and behaviour you want tight coupling to
import ../../globals
import amqpFactory
import type amqp

// Depend on interfaces and require injected behaviour and values without coupling to the concrete
require postgres as pg
require logger
require https://github.com/antirez/redis/archive/5.0.9.zip as redis
require type GetNow() => Integer as now

---

type EventQueue {
  connection: AMQPConnection
  channel: AMQPChannel
  boundQueues: Map<String AMQPQueue> = Map []
  bindingQueues: Map<String AMQPQueue> = Map []
}

exchangeName = "ad_event_queue"

type PublishingEvent { JSON }

publishEvent(queue: EventQueue, eventData: JSON) =>
  emit PublishingEvent{eventData}
  minute = eventData | jsonGet "data.time" | case
    JsonString{value} => dateFromString value
    JsonNumber{value} => dateFromUnixSeconds value
    Else => now() | dateFromUnixSeconds | withUTCSeconds 0 | withUTCMilliseconds 0 | inUnixSeconds
  parentId = eventData | jsonGet "data.line_item" | case
    JsonString{value} => value
    Else => "0"
  entityType = eventData | jsonGet "entity_type" | stringOr "unknown"
  eventId = eventData | jsonGet "id" | stringOr "unknown"
  q = "new.events.${minute}.${entityType}.${eventId}.${parentId}"
  sendEvent queue "events" eventData

type SetTimeout{Duration, Sink<Timeout>}
type Timeout
type Cancel

setBindTimeout(queue: EventQueue, queueName: String) =>
  queue.boundQueues[queueName] | case
    Just{job} => job | send Cancel
    None => {}
  queue.boundQueues[queueName] = spawn () =>
    emit SetTimeout{65 | Seconds, this}
    receive
      Timeout => queue.boundQueues | removeItem queueName
      Cancel => {}

type SendEventResult =
 | ErrorSendingEvent{queueName: String eventData: JSON error: Error}
 | EventSent{queueName: String}

sendEvent(queue: EventQueue, queueName: String, eventData: JSON) =>
  body = eventData | toString | toBuffer
  queue.channel | sendToQueue queueName body | case
    (error: Error) => ErrorSendingEvent{queueName, eventData, error}
    Else => EventSent{queueName}

connect(queueURI: String) =>
  onError (error) => ConnectionError{"Could not connect to the queue", error}
  onOk {}
  onFinish connection | close
  connection = connectToBroker queueURI ?
  channel = createChannel connection ?
  assertExchange channel exchangeName "topic" ~durable=false ?
  assertQueue channel "events" ~autoDelete=false ?
  EventQueue{channel, connection}

type GiveItem{Number}
type YieldItem{Number}

plusTen() =>
  receive GiveItem{number} => emit YieldItem{number + 10}
  plusTen()

test "plusTen can reply and await events" =>
  plusTen! &
    -| isTypeOf Coroutine<GiveItem YieldItem Never>
    -| send GiveItem{1}
    -| shouldProduce YieldItem{11}
    -| send GiveItem{2}
    -| shouldProduce YieldItem{12}
    -| send GiveItem{99}
    -| shouldProduce YieldItem{109}
    -| send GiveItem{99}
    -| shouldProduce YieldItem{109}

type Opponent{opponent: String}
type NoOpponent
type QueueOpponent{opponent: String}

warrior(name: String) =>
  receive
    Opponent{opponent} => say "${name} beat ${opponent}"
    NoOpponent => emit QueueOpponent{name}

battle() =>
  receive
    QueueOpponent{name} => emit Opponent{name}
  battle!

battleOfLanguages() =>
  battleBuffer = battle! &
  ["Go", "C", "C++", "Java", "Perl", "Python"] | map (language) =>
    battleBuffer | warrior language &^ | battleBuffer

test "The languages should battle as pairs" =>
  battleOfLanguages! &
    -| shouldProduce Say{"Go beat C"})
    -| shouldProduce Say{"C++ beat Java"})
    -| shouldProduce Say{"Perl beat Python"})

listener(name: String) => receive Say{data} => say "${name}: ${data}"

fanIn() =>
  listener "listener 1" &
    -| consume say "Hey 1" &
    -| consume say "Hey 2" &
    -| consume say "Hey 3" &

multicast() =>
  say "Hey 1" &
    -| pipe listener "listener 1" &
    -| pipe listener "listener 2" &
    -| pipe listener "listener 3" &

queueGroup() =>
  say "Hey 1" & | createQueueGroup
    -| pipe listener "listener 1")&)
    -| pipe listener "listener 2")&)
    -| pipe listener "listener 3")&)

type RRReply{Number}
type RRRequest{Number, Sink<RRReply>}

reqRepRequester(value: Number) =>
  emit RRRequest{value, this}
  receive RRReply{newValue} => say "I got ${newValue}"

reqRepReplyer() =>
  receive RRRequest{value, reply} => reply | send RRReply{value + 5}

requestReply() =>
  example = spawn () =>
    reqRepRequester 10
    reqRepRequester 20
    reqRepRequester 30
  example
    -| pipe reqRepReplyer! &
    -| shouldProduce Say{"I got 15"}
    -| shouldProduce Say{"I got 25"}
    -| shouldProduce Say{"I got 35"}

confirm(question: String) =>
  say "${question} (y/n)"
  stdin | readLine | toLowerCase | case
    ("y" or "yes") => True
    ("n" or "no") => False
    _ =>
      say "Please be clear: yes or no"
      confirm question

deleteStuff() =>
  confirm "Should I delete all your important files?" | case
    (True) => say "I'm sorry Dave, I'm afraid I can't do that."
    (False) => say "I think you know what the problem is just as well as I do."

test "delete stuff will keep asking until it gets a yes or no" =>
  deleteStuff! &
    -| shouldProduce Say{"Should I delete all your important files? (y/n)"}
    -| send ReadLine{"test"}
    -| shouldProduce Say{"Please be clear: yes or no"}
    -| shouldProduce Say{"Should I delete all your important files? (y/n)"}
    -| send ReadLine{"YES"}
    -| shouldProduce Say{"I'm sorry Dave, I'm afraid I can't do that."}

interface CastToString<T>
  toString(T) => String

type User{firstName: String, lastName: String, age: Number}

implement CastToString for User
  toString({firstName, lastName, age}) => "${firstName} ${lastName}, Age: ${age}"

type Say<T: CastToString>{T}

say<T: CastToString>(items: T) =>
  items | map
    (item) => item | toString | Say | emit

test "can say what a user is" =>
  User{"Simon", "Holloway", 26} | say &
    -| shouldProduce Say{"Simon Holloway, Age: 26"}

logSomeStuff() =>
  doThings 123 & | listen
    Say{content} =>
      log.info "Writing to output: ${content}"


type AckPolicy = AckNone | AckAll{wait: Number} | AckExplicit{wait: Number}
type StartPolicy =
 | DeliverAll
 | DeliverLast
 | StartTime
 | StreamSeq

type ReplayPolicy = ReplayInstant | ReplayOriginal

type ConsumerConfig {
  ackPolicy: AckPolicy
  startPolicy: StartPolicy
  deliverySubject: Optional{String}
  durable: String
  filterSubject: String
  maxDeliver: Number
  replayPolicy: ReplayPolicy
  sampleFrequency: Number
}

type InfoEvents =
 | GatheringInfo{request: Http.Request}
 | InfoGathered{count: Number}
 | MappingInfo
 | InfoMapped
 | ReducingInfo
 | InfoReduced

interface Repository<T>
  create(record: T) => T
  findOne(query: Partial<T>): T => findMany(query) | elementAt(0)
  findMany(query: Partial<T>) => List<T>
  delete(query: Partial<T>) => Number
  update(query: Partial<T>, record: Partial<T>) => T
  createMany(records: List<T>) => List<T>
  updateMany(query: Partial<T>, record: Partial<T>) => T

pgUsers() = pg | table("users")

implement Repository for User
  create(record) => pgUsers() | insert record
  findMany(query) => pgUsers() | findMany query
  delete(query) => pgUsers() | delete query
  update(query, record) => pgUsers() | update query record
  createMany(records) => pgUsers() | createMany records
  updateMany(query, records) => pgUsers() | updateMany query records

userFromHttpRequest(request: http.Request): User =>
  onError ParseError{"Could not get user from HTTP request"}
  jsonBody = request.body | toJson
  firstName = jsonBody | getStringOrError "data.first_name" ?
  lastName = jsonBody | getStringOrError "data.last_name" ?
  age = jsonBody | getIntegerOrError "data.age" ?
  User{firstName, lastName, age}

httpPostUser(request: http.Request) =>
  request | userFromHttpRequest ? | create

-- With DI

interface Store<T>
  getAddress(T) => String

type GetCoordinatesFromAddress
type MapAdapter(String) => {Number Number}
type StoreService{
  getCoordinatesFromAddress(Store) => {Number, Number}
}

storeService(mapAdapter: MapAdapter) => StoreService{
  getStoreCoordinates(store) => mapAdapter (store | getAddress)
}

googleMapsAdapter(address) =>
  googleMapsApi.makeRequest apiKey=GOOGLE_API_KEY address=address

openStreetMapAdapter(address) =>
  openStreetMapApi.makeRequest(
    apiKey = OSM_API_KEY
    address = address
  )

storeService(googleMapsAdapter)
  .getStoreCoordinates store

storeService(openStreetMapAdapter)
  .getStoreCoordinates store

-- With Coroutines

type GetCoordinatesFromAddress{address: String, reply: Sink<Coordinates>}
type Coordinates{Number, Number}

getStoreCoordinates(store) =>
  emit GetCoordinatesFromAddress{getAddress store, this}
  receive (coordinates: Coordinates) => coordinates

googleMapsAdapter() =>
  receive (request: GetCoordinatesFromAddress) =>
    googleMapsApi.makeRequest
      apiKey = GOOGLE_API_KEY
      address = request.address
    | Coordinates | send to = request.reply
  googleMapsAdapter!

openStreetMapAdapter() =>
  receive GetCoordinatesFromAddress as request =>
    openStreetMapApi.makeRequest
      apiKey = OSM_API_KEY
      address = request.address
    | Coordinates | send to = request.reply
  openStreetMapAdapter!

getStoreCoordinates store &
  -| pipe googleMapsAdapter &
   | await

getStoreCoordinates store &
  -| pipe openStreetMapAdapter &
   | await

type HttpHeader{String, String}
type HttpVerb = GET | POST | PATCH | PUT | DELETE
type HttpRequest{HttpVerb, Uri, List<HttpHeader>, Stream<List<Bytes>>}
type HttpResponse{Integer, List<HttpHeader>, Stream<List<Bytes>>}

makeHttpRequest(verb: HttpVerb, url: String): HttpRequest =>
  HttpRequest{verb, url, [], toByteStream ""}

sendHttpRequest(request: HttpRequest): HttpResponse =>
  emit request
  receive HttpResponse

request(verb: HttpVerb, url: String): Coroutine<HttpResponse, HttpRequest, HttpResponse> =>
  makeHttpRequest verb url | sendHttpRequest

R1 = request GET "https://example.com/1" & ^
R2 = request GET "https://example.com/1" & ^
R3 = request GET "https://example.com/1" & ^
awaitAll [R1, R2, R3]

deep = {
  nested = {
    object = {
      many = {
        levels = {
          value = 99
        }
      }
    }
  }
}

deep.nested.object.many.levels.value = 99

incrementValue(data) =>
  deep.nested.object.many.levels.value += 1
incrementValue(data) =>
  update deep.nested.object.many.levels.value (value) => 
    value + 1

--start

--data

title = "Roads Example"

owner.name = "Tom Preston-Werner"
owner.dob = 1979-05-27T07:32:00-08:00

database = {
  enabled = True
  ports = [ 8000, 8001, 8002 ]
  data = [ ["delta", "phi"], [3.14] ]
  temp_targets = { cpu = 79.5, case = 72.0 }
}

servers.alpha = {
  ip = "10.0.0.1"
  role = "frontend"
}

servers.beta = {
  ip = "10.0.0.2"
  role = "backend"
}

myKey = Base64 "
  TWFueSBoYW5kcyBtYW
  tlIGxpZ2h0IHdvcmsu
"

// Compact
title="Roads Example"
owner={name="Tom Preston-Werner",dob=1979-05-27T07:32:00-08:00}
database={enabled=True,ports=[8000,8001,8002],data=[["delta","phi"],[3.14]],temp_targets={cpu=79.5,case=72.0}}
servers={alpha={ip="10.0.0.1",role="frontend"},beta={ip="10.0.0.2",role="backend"}
myKey=Base64(TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcmsu)

--public

--private

--test
