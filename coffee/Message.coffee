class Message

  constructor: (properties = {}) ->
    @messageId = properties.messageId
    @routingKey = properties.routingKey
    @expiration = properties.expiration
    @userId = properties.userId
    @mandatory = properties.mandatory
    @persistent = properties.persistent
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

    @setHeaders properties.headers
    @setDefaults()

  setDefaults: ->
    @mandatory ?= false
    @persistent ?= false
    @immediate ?= false

  setHeaders: (headers = {}) ->
    @headers = headers

module.exports = Message
