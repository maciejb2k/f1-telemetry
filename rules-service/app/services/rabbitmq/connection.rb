module Rabbitmq
  class Connection
    def self.connection
      @connection ||= Bunny.new(ENV['RABBIT_URL'], log_level: :debug).tap(&:start)
    end

    def self.channel
      @channel ||= connection.create_channel
    end

    def self.exchange(name = 'telemetry', type = :topic)
      @exchange ||= channel.topic(name, durable: true)
    end
  end
end
