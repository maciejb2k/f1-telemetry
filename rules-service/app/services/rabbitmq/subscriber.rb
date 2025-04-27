module Rabbitmq
  class Subscriber
    def initialize(routing_key:, &block)
      @exchange = Rabbitmq::Connection.exchange
      @queue = Rabbitmq::Connection.channel.queue('', exclusive: true)
      @queue.bind(@exchange, routing_key: routing_key)
      @callback = block
    end

    def start
      @queue.subscribe(manual_ack: false, block: true) do |_delivery_info, _properties, body|
        payload = JSON.parse(body)
        puts payload
        @callback.call(payload)
      end
    end
  end
end
