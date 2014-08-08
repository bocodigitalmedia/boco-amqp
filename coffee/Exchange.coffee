class Exchange
  constructor: (properties = {}) ->
    @name = properties.name
    @type = properties.type
    @setOptions properties.options

  setOptions: (options) ->
    @options = new ExchangeOptions options

class ExchangeOptions
  
  constructor: (properties = {}) ->
    @durable = properties.durable
    @internal = properties.internal
    @autoDelete = properties.autoDelete
    @alternateExchange = properties.alternateExchange
    @setDefaults()

  setDefaults: ->
    @durable = false unless @durable?
    @internal = false unless @internal?
    @autoDelete = false unless @autoDelete?

Exchange.Options = ExchangeOptions
module.exports = Exchange
