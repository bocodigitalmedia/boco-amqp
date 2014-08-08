Queue = require './Queue'
Exchange = require './Exchange'

class Schema

  constructor: (properties = {}) ->
    @exchanges = properties.exchanges
    @queues = properties.queues
    @setDefaults()

  setDefaults: ->
    @exchanges = [] unless @exchanges?
    @queues = [] unless @queues?

  defineExchange: (name, type, options) ->
    exchange = new Exchange name: name, type: type, options: options
    @exchanges.push exchange
    return exchange

  defineQueue: (name, options) ->
    queue = new Queue name: name, options: options
    @queues.push queue
    return queue

module.exports = Schema
