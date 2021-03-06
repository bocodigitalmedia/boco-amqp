// Generated by CoffeeScript 1.6.3
(function() {
  var AMQPLibUtil, Async, Channel, Consume, Consumer, Message, Publish;

  Async = require('async');

  Consumer = require('./Consumer');

  Message = require('./Message');

  AMQPLibUtil = require('./AMQPLibUtil');

  Consume = require('./Consume');

  Publish = require('./Publish');

  Channel = (function() {
    function Channel(properties) {
      if (properties == null) {
        properties = {};
      }
      this.wrapped = properties.wrapped;
    }

    Channel.prototype.assertExchange = function(exchange, callback) {
      return this.wrapped.assertExchange(exchange.name, exchange.type, exchange.options, function(error) {
        return callback(error);
      });
    };

    Channel.prototype.assertQueue = function(queue, callback) {
      return this.wrapped.assertQueue(queue.name, queue.options, function(error) {
        return callback(error);
      });
    };

    Channel.prototype.bindQueue = function(binding, callback) {
      return this.wrapped.bindQueue(binding.queueName, binding.exchangeName, binding.pattern, binding["arguments"], function(error) {
        return callback(error);
      });
    };

    Channel.prototype.assertSchema = function(schema, callback) {
      var assertExchange, assertExchanges, assertQueue, assertQueues, bindQueue, bindQueues, channel, steps;
      channel = this;
      assertExchange = function(exchange, done) {
        return channel.assertExchange(exchange, done);
      };
      assertQueue = function(queue, done) {
        return channel.assertQueue(queue, done);
      };
      bindQueue = function(binding, done) {
        return channel.bindQueue(binding, done);
      };
      assertExchanges = function(done) {
        return Async.eachSeries(schema.exchanges, assertExchange, done);
      };
      assertQueues = function(done) {
        return Async.eachSeries(schema.queues, assertQueue, done);
      };
      bindQueues = function(done) {
        return Async.eachSeries(schema.queueBindings, bindQueue, done);
      };
      steps = [assertExchanges, assertQueues, bindQueues];
      return Async.series(steps, callback);
    };

    Channel.prototype.publish = function(params) {
      var options;
      params = new Publish(params);
      options = AMQPLibUtil.getOptionsForPublish(params);
      return this.wrapped.publish(params.exchangeName, params.routingKey, params.message.payload, options);
    };

    Channel.prototype.ack = function(message) {
      var amqpLibMessage;
      amqpLibMessage = AMQPLibUtil.createLibMessage(message);
      return this.wrapped.ack(amqpLibMessage);
    };

    Channel.prototype.nack = function(message, options) {
      var amqpLibMessage;
      if (options == null) {
        options = {};
      }
      if (options.requeue == null) {
        options.requeue = true;
      }
      amqpLibMessage = AMQPLibUtil.createLibMessage(message);
      return this.wrapped.nack(amqpLibMessage, false, options.requeue);
    };

    Channel.prototype.consume = function(params, callback) {
      var consumer, handleConsume, options, proxyMessage;
      if (params == null) {
        params = {};
      }
      params = new Consume(params);
      consumer = new Consumer({
        channel: this,
        queueName: params.queueName,
        consumerTag: params.consumerTag,
        handleMessage: params.handleMessage
      });
      proxyMessage = function(amqpLibMessage) {
        var message;
        message = new Message({
          payload: amqpLibMessage.content,
          properties: amqpLibMessage.properties,
          delivery: amqpLibMessage.fields
        });
        return consumer.handleMessage(message);
      };
      handleConsume = function(error, reply) {
        if (reply == null) {
          reply = {};
        }
        if (error != null) {
          return callback(error);
        }
        if (consumer.consumerTag == null) {
          consumer.consumerTag = reply.consumerTag;
        }
        return callback(null, consumer);
      };
      options = {
        noAck: params.noAck,
        exclusive: params.exclusive,
        priority: params.priority,
        "arguments": params["arguments"],
        consumerTag: params.consumerTag
      };
      this.wrapped.prefetch(params.prefetch);
      return this.wrapped.consume(params.queueName, proxyMessage, options, handleConsume);
    };

    Channel.prototype.cancel = function(consumerTag, callback) {
      return this.wrapped.cancel(consumerTag, function(error) {
        return callback(error);
      });
    };

    Channel.prototype.close = function(callback) {
      return this.wrapped.close(function(error) {
        return callback(error);
      });
    };

    return Channel;

  })();

  module.exports = Channel;

}).call(this);

/*
//@ sourceMappingURL=Channel.map
*/
