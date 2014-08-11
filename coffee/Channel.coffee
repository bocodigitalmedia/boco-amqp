Async = require 'async'

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

module.exports = Channel
