When = require 'when'
AMQPLib = require 'amqplib/callback_api'
Connection = require './Connection'

class AMQPService

  connect: (uri) ->
    deferred = When.defer()
    AMQPLib.connect uri, (error, connection) ->
      return deferred.reject error if error?
      return deferred.resolve connection
    new Connection
      uri: uri
      promiseForConnection: deferred.promise

module.exports = AMQPService
