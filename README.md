# boco-amqp

Boco AMQP wrapper.

    BocoAMQP = require 'boco-amqp'
    Async = require 'async'
    assert = require 'assert'
    tests = []

# Connection

Pass in an [AMQP URI] to the `connect` method to get a new connection:

    connection = BocoAMQP.connect "amqp://localhost"

# Channels

Create a channel using your connection as follows:

    channel = connection.createChannel()

## Confirmation Channel

A confirmation channel will ack/nack the `publish` and `sendToQueue` methods using the [confirmation mode] extension.

This channel type is best suited for producing important messages.

    confirmChannel = connection.createChannel confirmationMode: true
    
# Schemas

Schemas model the definitions for exchanges and queues.

    schema = new BocoAMQP.Schema()

## Defining An Exchange

Pass in the name and type of the exchange to the `defineExchange` method:

    exchange = schema.defineExchange "x-dead-letter", "fanout"

    assert.equal "x-dead-letter", exchange.name
    assert.equal "fanout", exchange.type

### Default Options

If you do not pass in the options for the exchange, defaults will be set automatically:

    options = exchange.options
    assert.equal false, options.durable
    assert.equal false, options.internal
    assert.equal false, options.autoDelete
    assert.equal undefined, options.alternateExchange

### Defining an Exchange With Options

Pass in an object as the last parameter to set options for the exchange:

    exchange = schema.defineExchange "x-user-messages", "direct",
      durable: true
      alternateExchange: "x-dead-letter"

    options = exchange.options
    assert.equal true, options.durable
    assert.equal "x-dead-letter", options.alternateExchange

## Defining Queues

Pass in the name of the queue to the `defineQueue` method.

    queue = schema.defineQueue "q-with-defaults"

### Default Options

If you do not pass in options for the queue, defaults will be set automatically:

    options = queue.options
    assert.equal false, options.durable
    assert.equal false, options.autoDelete
    assert.equal false, options.exclusive
    assert.equal undefined, options.arguments

### Defining a Queue With Options

Pass in an object as the last parameter to set options for the queue:

    queue = schema.defineQueue "q-users-john",
      durable: true
      autoDelete: true
      arguments:
        "x-dead-letter-exchange": "x-dead-letter"

    options = queue.options
    assert.equal true, queue.options.durable
    assert.equal true, queue.options.autoDelete

    args = options.arguments
    assert.equal "x-dead-letter", args["x-dead-letter-exchange"]

## Binding queues to exchanges

    binding = schema.defineQueueBinding "q-users-john", "x-user-messages", "users.john"

    assert.equal "q-users-john", binding.queueName
    assert.equal "x-user-messages", binding.exchangeName
    assert.equal "users.john", binding.pattern

## Assert a Schema

Assert the exchanges and queues defined in the schema by calling the `assertSchema` method on a channel, passing in your schema:

    tests.push (done) ->
      channel.assertSchema schema, done


<br><br><br><br>
---

_The following code executes the asynchronous tests in this README_

    Async.series tests, (error) ->
      throw error if error?
      connection.close (error) ->
        throw error if error?
        process.exit()

[AMQP URI]: https://www.rabbitmq.com/uri-spec.html
[confirmation mode]: https://www.rabbitmq.com/confirms.html
