# boco-amqp

Boco AMQP wrapper.

    BocoAMQP = require 'boco-amqp'
    Async = require 'async'
    assert = require 'assert'
    tests = []
    test = (name, fn) -> tests.push name: name, fn: fn

# Configuration

    config = {}
    amqp = BocoAMQP.createService config

# Usage

Let's define some global variables that will be assigned asynchronously...

    $connection = null
    $channel = null
    $publisher = null

## Connecting to the broker

Pass in an [AMQP URI] to the `connect` method to get a new connection. You will likely use one connection per app, and multiple channels (see below).

    test "connecting to a broker", (done) ->
      amqp.connect uri: "amqp://localhost", (error, connection) ->
        $connection = connection
        done error

## Creating channels


Channels are used for communication to the broker via the connection. All of the AMQP methods are performed over channels. For more information on channels, check out the [AMQP Concepts] page on RabbitMQ's site.

    test "creating a channel", (done) ->
      $connection.createChannel (error, channel) ->
        $channel = channel
        done error


## Defining a schema

Schemas model the definitions for exchanges and queues.

    schema = amqp.createSchema()


## Defining exchanges

Defining exchanges is easy. Just pass in the `name` and `type` followed by an optional `options` hash.

    schema.defineExchange "x-dead-letter", "fanout"

    schema.defineExchange "x-user-messages", "direct",
      durable: true
      alternateExchange: "x-dead-letter"

## Defining queues

Define a queue by passing in the `name` and an optional `options` hash.

    schema.defineQueue "q-with-defaults"

    schema.defineQueue "q-users-john",
      durable: true
      autoDelete: true
      arguments:
        "x-dead-letter-exchange": "x-dead-letter"

## Defining queue bindings

Define bindings by passing in the `queueName`, `exchangeName`, a routing `pattern`, and an optional `arguments` hash.

    schema.defineQueueBinding "q-users-john", "x-user-messages", "users.john"

## Asserting a schema

Assert the `exchanges` and `queues` defined in the schema by calling the `assertSchema` method on a channel, passing in your `schema` as the first parameter. This method is performed asynchronously, and utilizes a `callback` as the last parameter.

    test "asserting a schema", (done) ->
      $channel.assertSchema schema, done

## Creating a publisher

Publishers are used to publish messages. They use a channel that is configured to use the [confirmation mode] extension. This allows each `publish` to receive a callback when the message has been delivered.

    test "creating a publisher", (done) ->
      $connection.createPublisher (error, publisher) ->
        $publisher = publisher
        done error

## Creating Messages

    message = amqp.createMessage
      routingKey: "users.john"
      contentType: "text/plain"
      contentEncoding: "utf-8"
      payload: new Buffer "Hello, John."

## Publishing messages

    test "publishing a message", (done) ->
      $publisher.publish "x-user-messages", message, done

<br><br><br><br>
---

_The following code executes the asynchronous tests in this README_

    runTest = (test, done) ->
      console.log "* #{test.name}"
      test.fn done

    cleanUp = (error) ->
      console.error error if error?
      return unless $connection?
      $connection.close (error) ->
        throw error if error?

    Async.eachSeries tests, runTest, cleanUp


[AMQP URI]: https://www.rabbitmq.com/uri-spec.html
[confirmation mode]: https://www.rabbitmq.com/confirms.html
[AMQP Concepts]: https://www.rabbitmq.com/tutorials/amqp-concepts.html
