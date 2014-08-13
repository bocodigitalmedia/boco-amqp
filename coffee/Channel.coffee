Async = require 'async'
Consumer = require './Consumer'
Message = require './Message'

createIncomingMessage = (amqpLibMessage) ->

  message = new Message.IncomingMessage amqpLibMessage.properties
  message.wrapped = amqpLibMessage

  fields = amqpLibMessage.fields
  message.deliveryTag ?= fields.deliveryTag
  message.consumerTag ?= fields.consumerTag
  message.exchangeName ?= fields.exchange
  message.routingKey ?= fields.routingKey
  message.redelivered ?= fields.redelivered

  return message

getOptionsForPublish = (message) ->
  options =
    messageId: message.messageId
    expiration: message.expiration
    userId: message.userId
    mandatory: message.mandatory
    deliveryMode: message.deliveryMode
    immediate: message.immediate
    contentType: message.contentType
    contentEncoding: message.contentEncoding
    priority: message.priority
    correlationId: message.correlationId
    replyTo: message.replyTo
    timestamp: message.timestamp
    type: message.type
    headers: message.headers

  delete options[key] for own key,value of options when value is undefined
  return options

class ConsumeParameters

  constructor: (properties = {}) ->
    @noAck = properties.noAck
    @exclusive = properties.exclusive
    @priority = properties.priority
    @arguments = properties.arguments
    @prefetch = properties.prefetch
    @queueName = properties.queueName
    @consumerTag = properties.consumerTag
    @handleMessage = properties.handleMessage
    @setDefaults()

  setDefaults: ->
    @prefetch ?= 1
    @exclusive ?= false
    @noAck ?= false

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

  publish: (exchangeName, message) ->
    options = getOptionsForPublish message
    @wrapped.publish exchangeName, message.routingKey, content, options

  ack: (message) ->
    @wrapped.ack message.wrapped

  nack: (message, options = {}) ->
    options.requeue ?= true
    @wrapped.nack message.wrapped, false, options.requeue

  consume: (params = {}, callback) ->
    channel = this
    params = new ConsumeParameters params

    # Create a consumer for this channel
    consumer = new Consumer
      channel: channel
      queueName: params.queueName
      consumerTag: params.consumerTag
      handleMessage: params.handleMessage

    # Proxies messages to the consumer
    proxyMessage = (m) ->
      message = createIncomingMessage m
      message.channel = channel
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

class Channel.ConfirmChannel extends Channel

  publish: (exchangeName, message, callback) ->
    key = message.routingKey
    content = message.payload
    options = getOptionsForPublish message
    @wrapped.publish exchangeName, key, content, options, callback

module.exports = Channel
