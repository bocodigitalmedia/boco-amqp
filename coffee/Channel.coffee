Async = require 'async'
When = require 'when'

class Channel

  constructor: (properties = {}) ->
    @promiseForChannel = properties.promiseForChannel

  assertSchema: (schema, callback) ->

    assertExchangesAndQueues = (channel) ->

      assertExchange = (exch, done) ->
        channel.assertExchange exch.name, exch.type, exch.options, done
      assertExchanges = (done) ->
        Async.eachSeries schema.exchanges, assertExchange, done
      assertQueue = (queue, done) ->
        channel.assertQueue queue.name, queue.options, done
      assertQueues = (done) ->
        Async.eachSeries schema.queues, assertQueue, done
      bindQueue = (binding, done) ->
        channel.bindQueue binding.queueName, binding.exchangeName,
          binding.pattern, binding.arguments, done
      bindQueues = (done) ->
        Async.eachSeries schema.queueBindings, bindQueue, done

      steps = [assertExchanges, assertQueues, bindQueues]
      Async.series steps, (error) -> callback error

    @promiseForChannel
      .then(assertExchangesAndQueues)
      .done()
    return undefined

module.exports = Channel
