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

module.exports = Queue
