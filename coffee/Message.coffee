class Message

  constructor: (properties = {}) ->
    @messageId = properties.messageId
    @routingKey = properties.routingKey
    @expiration = properties.expiration
    @userId = properties.userId
    @mandatory = properties.mandatory
    @deliveryMode = properties.deliveryMode
    @immediate = properties.immediate
    @contentType = properties.contentType
    @contentEncoding = properties.contentEncoding
    @priority = properties.priority
    @correlationId = properties.correlationId
    @replyTo = properties.replyTo
    @timestamp = properties.timestamp
    @type = properties.type
    @appId = properties.appId
    @payload = properties.payload

    @deliveryTag = properties.deliveryTag
    @consumerTag = properties.consumerTag
    @exchangeName = properties.exchangeName
    @redelivered = properties.redelivered

    @setHeaders properties.headers
    @setDefaults()

  setDefaults: ->
    @mandatory ?= false
    @deliveryMode ?= 1
    @immediate ?= false

  setHeaders: (headers = {}) ->
    @headers = headers

module.exports = Message
