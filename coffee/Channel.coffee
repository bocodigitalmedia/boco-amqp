Async = require 'async'

# Get options for amqplib's publish method from our Message class object
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

  delete options[key] for own key, value of options when value is undefined
  options

# Channel class
class Channel

  constructor: (properties = {}) ->
    @wrapped = properties.wrapped

  assertExchange: (exchange, callback) ->
    x = exchange
    done = (error) -> callback error, exchange
    @wrapped.assertExchange x.name, x.type, x.options, done

  assertQueue: (queue, callback) ->
    q = queue
    done = (error) -> callback error, queue
    @wrapped.assertQueue q.name, q.options, done

  bindQueue: (binding, callback) ->
    b = binding
    done = (error) -> callback error, binding
    @wrapped.bindQueue b.queueName, b.exchangeName, b.pattern, b.arguments, done

  assertSchema: (schema, callback) ->
    assertExchange = @assertExchange.bind this
    assertQueue = @assertQueue.bind this
    bindQueue = @bindQueue.bind this

    assertExchanges = (done) ->
      Async.eachSeries schema.exchanges, assertExchange, done
    assertQueues = (done) ->
      Async.eachSeries schema.queues, assertQueue, done
    bindQueues = (done) ->
      Async.eachSeries schema.queueBindings, bindQueue, done

    steps = [assertExchanges, assertQueues, bindQueues]
    Async.series steps, callback

  publish: (exchangeName, message, callback) ->
    key = message.routingKey
    content = message.payload
    options = getOptionsForPublish message
    done = (error) -> callback error, message

    console.log "publishing to #{exchangeName}"
    console.log "message:", message
    console.log "options:", options
    
    if callback?
      return @wrapped.publish exchangeName, key, content, options, done
    else
      return @wrapped.publish exchangeName, key, content, options


module.exports = Channel
