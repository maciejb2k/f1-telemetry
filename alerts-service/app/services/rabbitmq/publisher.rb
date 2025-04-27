module Rabbitmq
  class Publisher
    def initialize(exchange_name: 'telemetry', exchange_type: :topic)
      @exchange = Rabbitmq::Connection.exchange(exchange_name, exchange_type)
    end

    def publish(routing_key:, payload:)
      @exchange.publish(payload.to_json, routing_key: routing_key)
    end
  end
end
