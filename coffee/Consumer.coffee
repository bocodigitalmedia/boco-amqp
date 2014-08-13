class Consumer
  constructor: (properties = {}) ->
    @prefetch = properties.prefetch
    @queueName = properties.queueName
    @handleMessage = properties.handleMessage
    @channel = properties.channel
    @consumerTag = properties.consumerTag
    @setDefaults()

  setDefaults: ->
    @prefetch ?= 1

  handleMessage: (incomingMessage) ->
    throw Error "Not Implemented"

  cancel: (callback) ->
    @channel.cancel @consumerTag, callback

module.exports = Consumer
