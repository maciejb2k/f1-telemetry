class RuleEvaluator
  def self.process(payload)

    publisher = Rabbitmq::Publisher.new
    publisher.publish(
      routing_key: "alert.1",
      payload: "NO KURWA NAUUURA"
    )

    car_code = payload['car_code'].to_i
    metric = payload['metric']
    value = payload['value'].to_f

    Rule.where(active: true, metric: metric).find_each do |rule|
      if rule.applies_to?(car_code, metric, value)
        Rails.logger.info "Rule matched: #{rule.inspect}"
        publish_alert(car_code, rule, payload)
      end
    end
  end

  def self.publish_alert(car_code, rule, payload)
    alert = {
      car_code: car_code,
      severity: rule.severity,
      message: "Rule triggered: #{payload['metric']}=#{payload['value']} (threshold: #{rule.operator} #{rule.threshold})",
      raised_at: Time.now.utc.iso8601
    }

    publisher = Rabbitmq::Publisher.new
    publisher.publish(
      routing_key: "alert.#{car_code}",
      payload: alert
    )
  end
end
