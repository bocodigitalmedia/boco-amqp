// Generated by CoffeeScript 1.6.3
(function() {
  var AMQPLib, AMQPService, Connection, Message, Schema, When;

  When = require('when');

  AMQPLib = require('amqplib/callback_api');

  Connection = require('./Connection');

  Schema = require('./Schema');

  Message = require('./Message');

  AMQPService = (function() {
    function AMQPService() {}

    AMQPService.prototype.connect = function(properties, callback) {
      if (properties == null) {
        properties = {};
      }
      return AMQPLib.connect(properties.uri, function(error, wrapped) {
        var connection;
        if (error != null) {
          return callback(error);
        }
        connection = new Connection(properties);
        connection.wrapped = wrapped;
        return callback(null, connection);
      });
    };

    AMQPService.prototype.createSchema = function(properties) {
      return new Schema(properties);
    };

    AMQPService.prototype.createMessage = function(properties) {
      return new Message(properties);
    };

    return AMQPService;

  })();

  module.exports = AMQPService;

}).call(this);

/*
//@ sourceMappingURL=Service.map
*/
