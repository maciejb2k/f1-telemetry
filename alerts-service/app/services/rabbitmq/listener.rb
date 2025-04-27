module Rabbitmq
  class Listener
    def self.start
      Subscriber.new(routing_key: 'rule.triggered') do |payload|
        AlertProcessor.process(payload)
      end.start
    end
  end
end
