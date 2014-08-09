When = require 'when'
Channel = require './Channel'

class Connection

  constructor: (properties = {}) ->
    @uri = properties.uri
    @promiseForConnection = properties.promiseForConnection

  createChannel: ->

    getPromiseForChannel = (connection) ->
      deferred = When.defer()
      connection.createChannel (error, channel) ->
        return deferred.reject error if error?
        return deferred.resolve channel
      return deferred.promise

    promiseForChannel = When(@promiseForConnection).then getPromiseForChannel
    new Channel promiseForChannel: promiseForChannel

  close: (callback) ->
    closeConnection = (connection) -> connection.close callback
    @promiseForConnection
      .then(closeConnection)
      .catch(callback)


module.exports = Connection
