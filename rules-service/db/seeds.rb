Rule.delete_all

rules_data = [
  { metric: 'tire_temp_fl', operator: '>', threshold: 110, severity: 'warning' },
  { metric: 'tire_temp_fr', operator: '>', threshold: 110, severity: 'warning' },
  { metric: 'tire_temp_rl', operator: '>', threshold: 110, severity: 'warning' },
  { metric: 'tire_temp_rr', operator: '>', threshold: 110, severity: 'warning' },
  { metric: 'brake_temp_fl', operator: '>', threshold: 800, severity: 'critical' },
  { metric: 'brake_temp_fr', operator: '>', threshold: 800, severity: 'critical' },
  { metric: 'brake_temp_rl', operator: '>', threshold: 800, severity: 'critical' },
  { metric: 'brake_temp_rr', operator: '>', threshold: 800, severity: 'critical' },
  { metric: 'engine_temp', operator: '>', threshold: 120, severity: 'critical' },
  { metric: 'oil_temp', operator: '>', threshold: 120, severity: 'warning' },
  { metric: 'fuel_level', operator: '<', threshold: 10, severity: 'warning' },
  { metric: 'gear', operator: '>', threshold: 8, severity: 'warning' },
  { metric: 'rpm', operator: '>', threshold: 14000, severity: 'critical' },
  { metric: 'speed', operator: '>', threshold: 350, severity: 'critical' },
  { metric: 'throttle', operator: '>', threshold: 100, severity: 'warning' },
  { metric: 'brake_pressure', operator: '>', threshold: 95, severity: 'warning' },
  { metric: 'g_force_lat', operator: '>', threshold: 4.5, severity: 'critical' },
  { metric: 'g_force_long', operator: '>', threshold: 4.5, severity: 'critical' },
  { metric: 'battery_voltage', operator: '<', threshold: 11.5, severity: 'warning' },
  { metric: 'drs_status', operator: '==', threshold: 1, severity: 'info' },
  { metric: 'ers_deployment', operator: '>', threshold: 90, severity: 'warning' },
  { metric: 'ers_charge', operator: '<', threshold: 30, severity: 'warning' }
]

rules = rules_data.map do |rule_attrs|
  Rule.create!(
    metric: rule_attrs[:metric],
    operator: rule_attrs[:operator],
    threshold: rule_attrs[:threshold],
    severity: rule_attrs[:severity],
    car_scope: 1,
    active: true
  )
end

puts "Rules seeded for Max Verstappen: #{rules.count}"
