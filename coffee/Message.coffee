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

    @setHeaders properties.header
    @setDefaults()

  setDefaults: ->
    @mandatory ?= false
    @deliveryMode ?= 1
    @immediate ?= false

  setHeaders: (headers = {}) ->
    @headers = headers

class Message.IncomingMessage extends Message

  constructor: (properties = {}) ->
    @channel = properties.channel
    @deliveryTag = properties.deliveryTag
    @consumerTag = properties.consumerTag
    @exchangeName = properties.exchangeName
    @redelivered = properties.redelivered

    super properties

  ack: ->
    @channel.ack this

  nack: (options) ->
    @channel.nack this, options

module.exports = Message
