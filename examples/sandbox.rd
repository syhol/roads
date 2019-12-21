import ../../globals
import date
import amqp as amqp

export type EventQueue =
  connection: amqp.Connection
  channel: amqp.Channel
  boundQueues: Map(String, amqp.Queue) = ()
  bindingQueues: Map(String, amqp.Queue) = ()

type PublishEvents = PublishingEvent(JSON) +> ()

exchangeName = "ad_event_queue"

export publishEvent = (queue: EventQueue, eventData: JSON) =>
  PublishingEvent(eventData)
  minute = eventData->jsonGet("data.time")
    ->case
      (value: Number) => value->Date
      (Else) => Date()
    ->setUTCSeconds(0)
    ->setUTCMilliseconds(0)
    ->getTime
  parentId = eventData->jsonGet("data.line_item")->case
    (value: String) => value
    (Else) => "0"
  q = "new.events.${minute}.${eventData.entity_type}.${eventData.id}.${parentId}"
  sendEvent(queue, "events", eventData)

export setBindTimeout = (queue: EventQueue, queueName: String) =>
  queue.boundQueues[queueName]->case (timeout: Timeout) => clearTimeout(timeout)
  queue.boundQueues[queueName] = setTimeout
    Seconds(65)
    () => queue.boundQueues->removeItem(queueName)

type ErrorSendingEvent = (queueName: String, eventData: JSON, error: Error)
type EventSent = (queueName: String)

export sendEvent = (queue: EventQueue, queueName: String, eventData: JSON) =>
  body = eventData->toString->toBuffer
  queue.channel->sendToQueue(queueName, body)->case
    (error: Error) => ErrorSendingEvent(queueName, eventData, error)
    (Else) => EventSent(queueName)

export connect = (queueURI: String) =>
  connection = amqp.ConnectToBroker(queueURI)?
  channel = amqp.CreateChannel(connection)?
  amqp.AssertExchange(channel, exchangeName, "topic", durable = false)?
  amqp.AssertQueue(channel, "events", autoDelete = false)?
  EventQueue((channel, connection)

type PlusTenEvents =
  | GetItem() +> Number
  | YieldItem(Number) +> ()

plusTen = (() => loop () => (GetItem() + 10)->YieldItem)()&

test "plusTen can listen and await events" =>
  plusTen
    ->listenOnce(GetItem => 1)
    ->listen(GetItem => 99)
    ->listenOnce(GetItem => 2)
  plusTen->waitFor(YieldItem)->shouldEqual(11)
  plusTen->waitFor(YieldItem)->shouldEqual(12)
  plusTen->waitFor(YieldItem)->shouldEqual(109)
  plusTen->waitFor(YieldItem)->shouldEqual(109)

type WarriorEvents =
  | GetOpponent() +> (String | ())
  | QueueOpponent(String) +> ()

warrior = (name: String) =>
  GetOpponent()->case
    (opponent: String) => say "${name} beat ${opponent}\n"
    () => QueueOpponent(name)

main = () =>
  battle: Queue(String) = Queue()
  ["Go", "C", "C++", "Java", "Perl", "Python"]
    ->map((language) => warrior(language))&
    ->listen
      GetOpponent => battle->pop
      QueueOpponent(name) => battle->push(name)
    ->await

test "The languages should battle as pairs" =>
  subject = main->async
  subject->waitFor(WriteToStream).content->shouldEqual("Go beat C")
  subject->waitFor(WriteToStream).content->shouldEqual("C++ beat Java")
  subject->waitFor(WriteToStream).content->shouldEqual("Perl beat Python")

confirm = (question: String) =>
  say("${question} (y/n)")
  loop () =>
    stdin->readLine->toLowerCase->case
      ("y"|"yes") => return True
      ("n"|"no") => return False
      (Else) => say("Please be clear: yes or no")

deleteStuff = () =>
  confirm("Should I delete all your important files?")->case
    (True) => say("I'm sorry Dave, I'm afraid I can't do that.")
    (False) => say("I think you know what the problem is just as well as I do.")

test "delete stuff will keep asking until it gets a yes or no" =>
  subject = deleteStuff->async

  subject->waitFor(WriteToStream).content
    ->shouldEqual("Should I delete all your important files? (y/n)")

  subject->listenOnce(ReadLineFromStream => "test")
  subject->waitFor(WriteToStream).content
    ->shouldEqual("Please be clear: yes or no")

  subject->listenOnce(ReadLineFromStream => "yes")
  subject->waitFor(WriteToStream).content
    ->shouldEqual("I'm sorry Dave, I'm afraid I can't do that.")

  subject->await

-- Annoying things
return

say = (...items: ToString[]) =>
  items->map
    (item) => item->toString->WriteToStream(stream = stdout)

logSomeStuff = () =>
  (() => doThings(123))->async->listen
    (event: WriteToStream) =>
      log.info("Writing to stream", event)
      event()
