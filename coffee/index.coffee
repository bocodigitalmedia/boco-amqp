When = require 'when'
AMQPLib = require 'amqplib/callback_api'
Connection = require './Connection'

exports.Queue = require './Queue'
exports.Exchange = require './Exchange'
exports.Schema = require './Schema'
exports.Channel = require './Channel'
exports.Connection = require './Connection'

exports.connect = (uri) ->
  deferred = When.defer()
  AMQPLib.connect uri, (error, connection) ->
    return deferred.reject error if error?
    return deferred.resolve connection
  new Connection uri: uri, promiseForConnection: deferred.promise
