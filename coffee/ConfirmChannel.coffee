Channel = require './Channel'
AMQPLibUtil = require './AMQPLibUtil'
Publish = require './Publish'

class ConfirmChannel extends Channel

  publish: (params, callback) ->
    params = new Publish params
    options = AMQPLibUtil.getOptionsForPublish params
    @wrapped.publish params.exchangeName, params.routingKey,
      params.message.payload, options, callback

module.exports = ConfirmChannel
