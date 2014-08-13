module.exports =

  getOptionsForPublish: (params) ->
    options = {}
    options[key] = val for own key,val of params.message.properties when val?
    options.mandatory = params.mandatory if params.mandatory?
    return options

  createLibMessage: (message) ->
    fields: message.delivery
    properties: message.properties
    content: message.payload
