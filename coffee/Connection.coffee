When = require 'when'
Channel = require './Channel'

class Connection

  constructor: (properties = {}) ->
    @uri = properties.uri
    @promiseForConnection = properties.promiseForConnection

  createChannel: (options = {}) ->

    getPromiseForChannel = (connection) ->
      deferred = When.defer()
      type =  if options.confirmationMode then "ConfirmChannel" else "Channel"
      connection["create#{type}"] (error, channel) ->
        return deferred.reject error if error?
        return deferred.resolve channel
      return deferred.promise

    promiseForChannel = When(@promiseForConnection).then getPromiseForChannel

    new Channel
      promiseForChannel: promiseForChannel

  close: (callback) ->
    @promiseForConnection.then (connection) ->
      connection.close callback

module.exports = Connection
