Channel = require './Channel'

class Connection

  constructor: (properties = {}) ->
    @uri = properties.uri
    @wrapped = properties.wrapped

  createChannel: (properties, callback) ->
    @wrapped.createChannel (error, wrapped) ->
      return callback error if error?
      channel = new Channel properties
      channel.wrapped = wrapped
      callback null, channel

  close: (callback) ->
    @wrapped.close (error) -> callback error


module.exports = Connection
