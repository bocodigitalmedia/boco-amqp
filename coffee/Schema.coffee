Queue = require './Queue'
Exchange = require './Exchange'
QueueBinding = require './QueueBinding'

class Schema

  constructor: (properties = {}) ->
    @exchanges = properties.exchanges
    @queues = properties.queues
    @queueBindings = properties.queueBindings
    @setDefaults()

  setDefaults: ->
    @exchanges = [] unless @exchanges?
    @queues = [] unless @queues?
    @queueBindings = [] unless @queueBindings?

  defineExchange: (name, type, options) ->
    exchange = new Exchange name: name, type: type, options: options
    @exchanges.push exchange
    return exchange

  defineQueue: (name, options) ->
    queue = new Queue name: name, options: options
    @queues.push queue
    return queue

  defineQueueBinding: (queue, exchange, pattern, args) ->
    binding = new QueueBinding
      queueName: queue
      exchangeName: exchange
      pattern: pattern
      arguments: args
    @queueBindings.push binding
    return binding

module.exports = Schema
