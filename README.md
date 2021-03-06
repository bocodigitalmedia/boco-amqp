# boco-amqp

Boco AMQP wrapper.

    BocoAMQP = require 'boco-amqp'
    Async = require 'async'

The following code allows us to build up a "suite" of tests to run asynchronously at the end of this README.

    tests = []
    test = (name, fn) -> tests.push name: name, fn: fn

# Configuration

    config = {}
    amqp = BocoAMQP.createService config

# Usage

Let's define some global variables that will be assigned asynchronously...

    $connection = null
    $channel = null
    $confirmChannel = null
    $consumer = null

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

    schema.defineQueue "q-dead-letters",
      durable: true

    schema.defineQueue "q-users-john",
      durable: true
      arguments:
        "x-dead-letter-exchange": "x-dead-letter"

## Defining queue bindings

Define bindings by passing in the `queueName`, `exchangeName`, a routing `pattern`, and an optional `arguments` hash.

    schema.defineQueueBinding "q-users-john", "x-user-messages", "users.john"
    schema.defineQueueBinding "q-dead-letters", "x-dead-letter", "$"

## Asserting a schema

Assert the `exchanges` and `queues` defined in the schema by calling the `assertSchema` method on a channel, passing in your `schema` as the first parameter. This method is performed asynchronously, and utilizes a `callback` as the last parameter.

    test "asserting a schema", (done) ->
      $channel.assertSchema schema, done

## Creating a confirmation channel.

A special type of channel that is configured to use the [confirmation mode] extension. This allows each `publish` to receive a callback when the message has been delivered.

    test "creating a channel in confirmation mode", (done) ->
      $connection.createConfirmChannel (error, confirmChannel) ->
        $confirmChannel = confirmChannel
        done error

## Creating Messages

Create a message by passing in the message `properties` to the `createMessage` method.

    message = amqp.createMessage
      payload: new Buffer "Hello, John."
      properties:
        messageId: require("uuid").v4()
        contentType: "text/plain"
        contentEncoding: "utf-8"
        deliveryMode: 2

## Publishing messages

It is suggested to publish messages using a `confirmChannel` so that you may receive notification of the message being sent.

    test "publishing a message", (done) ->

      params =
        exchangeName: "x-user-messages"
        routingKey: "users.john"
        mandatory: false # mandatory messages will be returned
        message: message
      $confirmChannel.publish params, done


## Consuming messages

    test "consuming messages", (done) ->

Define a handler for the message. The handler should `ack` or `nack` the message when finished. You may reject the message by passing `requeue: false` to `nack`.

      handleMessage = (message) ->
        # do something with this message...
        console.log message
        $channel.nack message, requeue: false


Call the `consume` method on the channel you wish to use, passing in the `parameters` object, and a `callback`. A `Consumer` will be created and returned asynchronously.

      params =
        noAck: false # default
        exclusive: false # default
        prefetch: 1 # get 1 message at a time until ack'ed
        queueName: "q-users-john"
        handleMessage: handleMessage

      $channel.consume params, (error, consumer) ->
        return done error if error?
        $consumer = consumer
        setTimeout done, 100

## Cancelling a consumer

Cancelling a consumer will prevent it from processing further messages.

    test "cancelling a consumer", (done) ->
      $consumer.cancel done

<br><br><br><br>
---

_The following code executes the asynchronous tests in this README_

    # Run a single test
    runTest = (test, done) ->
      console.log "* #{test.name}"
      test.fn done

    # Clean up when tests fail or are finished
    cleanUp = (error) ->
      console.error error if error?
      return unless $connection?
      $connection.close (error) ->
        throw error if error?

    # Run all the tests now
    Async.eachSeries tests, runTest, cleanUp unless module.parent?


[AMQP URI]: https://www.rabbitmq.com/uri-spec.html
[confirmation mode]: https://www.rabbitmq.com/confirms.html
[AMQP Concepts]: https://www.rabbitmq.com/tutorials/amqp-concepts.html
