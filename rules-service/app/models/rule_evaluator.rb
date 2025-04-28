class RuleEvaluator
  class << self
    def process(payload)
      payload = JSON.parse(payload) if payload.is_a?(String)

      car_code  = payload['car_code'].to_i
      metric    = payload['metric']
      value     = payload['value'].to_f
      timestamp = Time.current

      Rule.active.where(metric: metric).find_each do |rule|
        next unless rule.applies_to_car?(car_code)

        publish_trigger(rule, car_code, value, timestamp) if rule.condition_met?(value)
      end
    end

    def publish_trigger(rule, car_code, value, timestamp)
      Rabbitmq::Publisher.new.publish(
        routing_key: 'rule.triggered',
        payload: {
          rule_id:   rule.id,
          car_code:  car_code,
          metric:    rule.metric,
          operator:  rule.operator,
          threshold: rule.threshold,
          value:     value,
          severity:  rule.severity,
          timestamp: timestamp.iso8601
        }
      )
    end
  end
end
