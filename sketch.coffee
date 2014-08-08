BocoRabbit = require 'boco-rabbit'

schema = new BocoRabbit.Schema()

schema.defineExchange "x-dead-letter", "fanout"

schema.defineExchange "x-events", "direct",
  durable: true
  alternateExchange: "x-dead-letter"

schema.defineQueue "q-users-john",
  durable: true
  autoDelete: true
  arguments:
    "x-dead-letter-exchange": "x-dead-letter"

schema.defineQueue "q-defaults"

console.log JSON.stringify(schema, null, 2)

connection = BocoRabbit.connect "amqp://localhost"
channel = connection.createChannel()

channel.assertSchema schema, (error) ->
  throw error if error?
  console.log "schema asserted."
  process.exit()
