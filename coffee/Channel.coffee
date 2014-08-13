Async = require 'async'
Consumer = require './Consumer'
Message = require './Message'
AMQPLibUtil = require './AMQPLibUtil'
Consume = require './Consume'
Publish = require './Publish'

class Channel

  constructor: (properties = {}) ->
    @wrapped = properties.wrapped

  assertExchange: (exchange, callback) ->
    @wrapped.assertExchange exchange.name, exchange.type, exchange.options,
      (error) -> callback error

  assertQueue: (queue, callback) ->
    @wrapped.assertQueue queue.name, queue.options,
      (error) -> callback error

  bindQueue: (binding, callback) ->
    @wrapped.bindQueue binding.queueName, binding.exchangeName,
      binding.pattern, binding.arguments,
      (error) -> callback error

  assertSchema: (schema, callback) ->
    channel = this

    # create methods pre-bound to this channel
    assertExchange = (exchange, done) ->
      channel.assertExchange exchange, done
    assertQueue = (queue, done) ->
      channel.assertQueue queue, done
    bindQueue = (binding, done) ->
      channel.bindQueue binding, done

    assertExchanges = (done) ->
      Async.eachSeries schema.exchanges, assertExchange, done
    assertQueues = (done) ->
      Async.eachSeries schema.queues, assertQueue, done
    bindQueues = (done) ->
      Async.eachSeries schema.queueBindings, bindQueue, done

    steps = [assertExchanges, assertQueues, bindQueues]
    Async.series steps, callback

  publish: (params) ->
    params = new Publish params
    options = AMQPLibUtil.getOptionsForPublish params
    @wrapped.publish params.exchangeName, params.routingKey,
      params.message.payload, options

  ack: (message) ->
    amqpLibMessage = AMQPLibUtil.createLibMessage message
    @wrapped.ack amqpLibMessage

  nack: (message, options = {}) ->
    options.requeue ?= true
    amqpLibMessage = AMQPLibUtil.createLibMessage message
    @wrapped.nack amqpLibMessage, false, options.requeue

  consume: (params = {}, callback) ->
    params = new Consume params

    # Create a consumer for this channel
    consumer = new Consumer
      channel: this
      queueName: params.queueName
      consumerTag: params.consumerTag
      handleMessage: params.handleMessage

    # Proxies messages to the consumer
    proxyMessage = (amqpLibMessage) ->
      message = new Message
        payload: amqpLibMessage.content
        properties: amqpLibMessage.properties
        delivery: amqpLibMessage.fields
      consumer.handleMessage message

    # Handles the result of the consume method
    handleConsume = (error, reply = {}) ->
      return callback error if error?
      consumer.consumerTag ?= reply.consumerTag
      callback null, consumer

    # Get the options for amqplib's consume from our params object
    options =
      noAck: params.noAck
      exclusive: params.exclusive
      priority: params.priority
      arguments: params.arguments
      consumerTag: params.consumerTag

    # Set the prefetch and then begin consuming from the queue
    @wrapped.prefetch params.prefetch
    @wrapped.consume params.queueName, proxyMessage, options, handleConsume

  cancel: (consumerTag, callback) ->
    @wrapped.cancel consumerTag, (error) -> callback error

  close: (callback) ->
    @wrapped.close (error) -> callback error

module.exports = Channel
