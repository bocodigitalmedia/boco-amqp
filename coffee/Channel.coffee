Async = require 'async'
When = require 'when'

class Channel

  constructor: (properties = {}) ->
    @connection = properties.connection
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

      Async.series [assertExchanges, assertQueues], (error) -> callback error

    When(@promiseForChannel)
      .then(assertExchangesAndQueues)
      .catch (error) -> callback error
      .done()

    return undefined

module.exports = Channel
