# Get options for amqplib's publish method from our Message class object
getOptionsForPublish = (message) ->
  options =
    messageId: message.messageId
    expiration: message.expiration
    userId: message.userId
    mandatory: message.mandatory
    persistent: message.persistent
    immediate: message.immediate
    contentType: message.contentType
    contentEncoding: message.contentEncoding
    priority: message.priority
    correlationId: message.correlationId
    replyTo: message.replyTo
    timestamp: message.timestamp
    type: message.type
    headers: message.headers

  delete options[key] for own key, value of options when value is undefined
  return options

class Publisher
  constructor: (properties = {}) ->
    @wrapped = properties.wrapped

  publish: (exchangeName, message, callback) ->
    key = message.routingKey
    content = message.payload
    options = getOptionsForPublish message
    done = (error) -> callback error, message
    @wrapped.publish exchangeName, key, content, options, done

module.exports = Publisher
