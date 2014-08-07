class Queue
  constructor: (properties = {}) ->
    @name = properties.name
    @setOptions properties.options

  setOptions: (options) ->
    @options = new QueueOptions options

class QueueOptions
  constructor: (properties = {}) ->
    @exclusive = properties.exclusive
    @durable = properties.durable
    @autoDelete = properties.autoDelete
    @arguments = properties.arguments
    @setDefaults()

  setDefaults: ->
    @exclusive = false unless @exclusive?
    @durable = false unless @durable?
    @autoDelete = false unless @autoDelete?

class Exchange
  constructor: (properties = {}) ->
    @name = properties.name
    @type = properties.type
    @setOptions properties.options

  setOptions: (options) ->
    @options = new ExchangeOptions options

class ExchangeOptions
  constructor: (properties = {}) ->
    @durable = properties.durable
    @internal = properties.internal
    @autoDelete = properties.autoDelete
    @setDefaults()

  setDefaults: ->
    @durable = false unless @durable?
    @internal = false unless @internal?
    @autoDelete = false unless @autoDelete?

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

  defineQueue: (name, options) ->
    queue = new Queue name: name, options: options
    @queues.push queue

schema = new Schema()

schema.defineExchange "x-dead-letter", "fanout"

schema.defineExchange "x-events", "direct",
  durable: true
  arguments:
    "x-alternate-exchange": "x-alt"

schema.defineQueue "q-users-john",
  durable: false
  autoDelete: true
  arguments:
    "x-dead-letter-queue": "x-dead-letter"

schema.defineQueue "q-defaults"

console.log JSON.stringify(schema, null, 2)
