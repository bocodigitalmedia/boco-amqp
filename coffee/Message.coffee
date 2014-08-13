class BasicProperties

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

class BasicDeliver
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
    @delivery = new BasicDeliver properties

  setProperties: (properties) ->
    @properties = new BasicProperties properties

  setPayload: (buffer) ->
    @payload = buffer

module.exports = Message
