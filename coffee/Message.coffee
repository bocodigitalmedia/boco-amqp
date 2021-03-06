class MessageProperties

  constructor: (properties = {}) ->
    @appId = properties.appId
    @contentEncoding = properties.contentEncoding
    @contentType = properties.contentType
    @correlationId = properties.correlationId
    @deliveryMode = properties.deliveryMode
    @expiration = properties.expiration
    @messageId = properties.messageId
    @priority = properties.priority
    @replyTo = properties.replyTo
    @timestamp = properties.timestamp
    @type = properties.type
    @userId = properties.userId

    @setHeaders properties.headers

  setHeaders: (headers = {}) ->
    @headers = headers

class MessageDelivery # see: BasicDeliver (RabbitMQ)
  constructor: (properties = {}) ->
    @deliveryTag = properties.deliveryTag
    @consumerTag = properties.consumerTag
    @exchange = properties.exchange
    @routingKey = properties.routingKey
    @redelivered = properties.redelivered

class Message

  constructor: (properties = {}) ->
    @setProperties properties.properties
    @setDelivery properties.delivery
    @setPayload properties.payload

  setDelivery: (properties) ->
    @delivery = new MessageDelivery properties

  setProperties: (properties) ->
    @properties = new MessageProperties properties

  setPayload: (buffer) ->
    @payload = buffer

module.exports = Message
