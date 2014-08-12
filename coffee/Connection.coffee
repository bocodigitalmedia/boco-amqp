Channel = require './Channel'

class Connection

  constructor: (properties = {}) ->
    @uri = properties.uri
    @wrapped = properties.wrapped

  createChannel: (callback) ->
    @wrapped.createChannel (error, wrapped) ->
      return callback error if error?
      channel = new Channel wrapped: wrapped
      callback null, channel

  createConfirmChannel: (callback) ->
    @wrapped.createConfirmChannel (error, wrapped) ->
      return callback error if error?
      confirmChannel = new Channel.ConfirmChannel wrapped: wrapped
      callback null, confirmChannel

  close: (callback) ->
    @wrapped.close (error) -> callback error


module.exports = Connection
