class RuleEvaluator
  class << self
    def process(payload)
      payload = JSON.parse(payload) if payload.is_a?(String)

      car_code = payload['car_code'].to_i
      metric   = payload['metric']
      value    = payload['value'].to_f
      timestamp = Time.current

      puts "Processing payload: #{payload}"

      Rule.active.where(metric: metric).find_each do |rule|
        puts "Processing rule: #{rule.id} for car_code: #{car_code}, metric: #{metric}, value: #{value}"
        next unless rule.applies_to_car?(car_code)

        puts "Checking condition for rule: #{rule.id} with value: #{value}"

        if rule.condition_met?(value)
          puts "Condition met for rule: #{rule.id} with value: #{value}"
          publish_trigger(rule, car_code, value, timestamp)
        end
      end
    end

    def publish_trigger(rule, car_code, value, timestamp)
      puts "Publishing trigger for rule #{rule.id} with value #{value} at #{timestamp}"

      Rabbitmq::Publisher.new.publish(
        routing_key: 'rule.triggered',
        payload: {
          rule_id:  rule.id,
          car_code: car_code,
          metric:   rule.metric,
          operator: rule.operator,
          threshold: rule.threshold,
          value:    value,
          severity: rule.severity,
          timestamp: timestamp.iso8601
        }
      )
    end
  end
end
