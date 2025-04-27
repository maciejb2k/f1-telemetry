require 'bunny'

class RabbitmqPublisher
  def self.instance
    @instance ||= new
  end

  def initialize(exchange_name: 'telemetry', exchange_type: :topic)
    @connection ||= Bunny.new(ENV['RABBIT_URL']).tap(&:start)
    @channel = @connection.create_channel
    @exchange = @channel.send(exchange_type, exchange_name, durable: true)
  end

  def publish(routing_key:, payload:)
    @exchange.publish(payload.to_json, routing_key: routing_key)
  end
end
