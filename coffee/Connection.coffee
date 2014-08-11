Channel = require './Channel'
Publisher = require './Publisher'

class Connection

  constructor: (properties = {}) ->
    @uri = properties.uri
    @wrapped = properties.wrapped

  createChannel: (callback) ->
    @wrapped.createChannel (error, wrapped) ->
      return callback error if error?
      channel = new Channel wrapped: wrapped
      callback null, channel

  createPublisher: (callback) ->
    @wrapped.createConfirmChannel (error, wrapped) ->
      return callback error if error?
      publisher = new Publisher wrapped: wrapped
      callback null, publisher

  close: (callback) ->
    @wrapped.close (error) -> callback error


module.exports = Connection
