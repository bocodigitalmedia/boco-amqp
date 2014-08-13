class Consumer
  constructor: (properties = {}) ->
    @queueName = properties.queueName
    @handleMessage = properties.handleMessage
    @channel = properties.channel
    @consumerTag = properties.consumerTag

  cancel: (callback) ->
    @channel.cancel @consumerTag, callback

module.exports = Consumer
