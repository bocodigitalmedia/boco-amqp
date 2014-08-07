BocoRabbit = require 'boco-rabbit'

schema = new BocoRabbit.Schema()

schema.defineExchange "x-dead-letter", "fanout"

schema.defineExchange "x-events", "direct",
  durable: true
  arguments:
    "x-alternate-exchange": "x-alt"

schema.defineQueue "q-users-john",
  durable: false
  autoDelete: true
  arguments:
    "x-dead-letter-queue": "x-dead-letter"

schema.defineQueue "q-defaults"

console.log JSON.stringify(schema, null, 2)
