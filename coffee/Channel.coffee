Async = require 'async'

getOptionsForPublish = (message) ->
  options =
    messageId: message.messageId
    expiration: message.expiration
    userId: message.userId
    mandatory: message.mandatory
    persistent: message.persistent
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

  close: (callback) ->
    @wrapped.close (error) -> callback error

class Channel.ConfirmChannel extends Channel

  publish: (exchangeName, message, callback) ->
    key = message.routingKey
    content = message.payload
    options = getOptionsForPublish message
    @wrapped.publish exchangeName, key, content, options, callback

module.exports = Channel
