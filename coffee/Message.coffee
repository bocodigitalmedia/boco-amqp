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

  carbonCopy: (routingKeys...) ->
    current = if @headers.CC? then @headers.CC else []
    @headers.CC = current.concat routingKeys

  blindCarbonCopy: (routingKeys...) ->
    current = if @headers.BCC? then @headers.BCC else []
    @headers.BCC = current.concat routingKeys

module.exports = Message
