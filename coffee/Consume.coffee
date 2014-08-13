class Consume

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

module.exports = Consume
