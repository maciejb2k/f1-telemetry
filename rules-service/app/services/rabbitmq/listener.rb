module Rabbitmq
  class Listener
    def self.start
      Subscriber.new(routing_key: 'reading.#') do |payload|
        RuleEvaluator.process(payload)
      end.start
    end
  end
end
