class QueueBinding
  constructor: (properties = {}) ->
    @queueName = properties.queueName
    @exchangeName = properties.exchangeName
    @pattern = properties.pattern
    @arguments = properties.arguments

module.exports = QueueBinding
