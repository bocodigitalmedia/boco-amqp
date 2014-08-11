# boco-amqp

Boco AMQP wrapper.

    BocoAMQP = require 'boco-amqp'
    Async = require 'async'
    assert = require 'assert'
    tests = []

# Configuration

    config = {}
    amqp = BocoAMQP.createService config

# Usage

Let's define some global variables that will be assigned asynchronously...

    $connection = null
    $channel1 = null

## Connecting to the broker

Pass in an [AMQP URI] to the `connect` method to get a new connection. You will likely use one connection per app, and multiple channels (see below).

    tests.push (done) -> # execute async
      amqp.connect uri: "amqp://localhost", (error, connection) ->
        return done error if error?
        $connection = connection
        done()

## Creating channels

Channels are used for communication to the broker via the connection. All of the AMQP methods are performed over channels. For more information on channels, check out the [AMQP Concepts] page on RabbitMQ's site.

    tests.push (done) -> # execute async
      properties = {}
      $connection.createChannel properties, (error, channel) ->
        return done error if error?
        $channel1 = channel
        done()


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

    tests.push (done) -> # execute async
      $channel1.assertSchema schema, done


## Creating messages

    message = new BocoAMQP.Message
      routingKey: "users.john"
      contentType: "text/plain"
      contentEncoding: "utf-8"

    message.payload = new Buffer "Hello, John."

    message.carbonCopy "users.jane"
    message.blindCarbonCopy "users.secret"
    
## Publishing messages

    tests.push (done) ->
      $channel1.publish "x-user-messages", message, (error) ->
        return done error if error?
        console.log "published message."
        done()



<br><br><br><br>
---

_The following code executes the asynchronous tests in this README_

    Async.series tests, (error) ->
      throw error if error?
      $connection.close (error) ->
        throw error if error?
        process.exit()

[AMQP URI]: https://www.rabbitmq.com/uri-spec.html
[confirmation mode]: https://www.rabbitmq.com/confirms.html
[AMQP Concepts]: https://www.rabbitmq.com/tutorials/amqp-concepts.html
