When = require 'when'
AMQPLib = require 'amqplib/callback_api'
Connection = require './Connection'
Schema = require './Schema'
Message = require './Message'

class AMQPService

  connect: (properties = {}, callback) ->

    AMQPLib.connect properties.uri, (error, wrapped) ->
      return callback error if error?
      connection = new Connection properties
      connection.wrapped = wrapped
      callback null, connection

  createSchema: (properties) ->
    new Schema properties

  createMessage: (properties) ->
    new Message properties

module.exports = AMQPService
