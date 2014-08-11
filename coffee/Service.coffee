When = require 'when'
AMQPLib = require 'amqplib/callback_api'
Connection = require './Connection'
Schema = require './Schema'

class AMQPService

  connect: (properties = {}, callback) ->

    AMQPLib.connect properties.uri, (error, wrapped) ->
      return callback error if error?
      connection = new Connection properties
      connection.wrapped = wrapped
      callback null, connection

  createSchema: (properties) ->
    new Schema properties

module.exports = AMQPService
