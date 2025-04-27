class AlertProcessor
  def self.process(event)
    rule_id = event['rule_id']
    car_code = event['car_code']
    value = event['value'].to_f
    now = Time.current

    alert = Alert.active.find_by(rule_id: rule_id, car_code: car_code)

    if alert
      return if Rails.cache.read("alert:#{alert.id}:snoozed")

      if !alert.acknowledged? && now - alert.last_trigger_at >= 5.seconds
        alert.update!(last_value: value, last_trigger_at: now)
      else
        alert.update!(last_trigger_at: now, last_value: value)
      end
    else
      Alert.create!(
        rule_id: rule_id,
        car_code: car_code,
        metric: event['metric'],
        threshold: event['threshold'],
        operator: event['operator'],
        last_value: value,
        severity: event['severity'],
        opened_at: now,
        last_trigger_at: now
      )
    end
  end
end