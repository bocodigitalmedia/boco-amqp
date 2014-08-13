Message = require './Message'

class Publish

  constructor: (properties = {}) ->
    @exchangeName = properties.exchangeName
    @routingKey = properties.routingKey
    @mandatory = properties.mandatory
    @setMessage properties.message
    @setDefaults()

  setMessage: (message) ->
    return @message = message if message instanceof Message
    @message = new Message message

  setDefaults: ->
    @mandatory ?= false

module.exports = Publish
