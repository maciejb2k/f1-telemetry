Rule.delete_all

Rule.create!([
  # Opony – warning i critical
  {
    metric: 'tire_temp_fl',
    operator: '>',
    threshold: 110,
    severity: 'warning',
    car_scope: 1,
    active: true
  },
  {
    metric: 'tire_temp_fl',
    operator: '>',
    threshold: 130,
    severity: 'critical',
    car_scope: 1,
    active: true
  },
  {
    metric: 'tire_temp_fr',
    operator: '>',
    threshold: 110,
    severity: 'warning',
    car_scope: 1,
    active: true
  },
  {
    metric: 'tire_temp_fr',
    operator: '>',
    threshold: 130,
    severity: 'critical',
    car_scope: 1,
    active: true
  },
  {
    metric: 'tire_temp_rl',
    operator: '>',
    threshold: 110,
    severity: 'warning',
    car_scope: 1,
    active: true
  },
  {
    metric: 'tire_temp_rr',
    operator: '>',
    threshold: 110,
    severity: 'warning',
    car_scope: 1,
    active: true
  },

  # ERS Charge – warning
  {
    metric: 'ers_charge',
    operator: '<',
    threshold: 30,
    severity: 'warning',
    car_scope: 1,
    active: true
  },

  # Engine Temp – critical
  {
    metric: 'engine_temp',
    operator: '>',
    threshold: 120,
    severity: 'critical',
    car_scope: 1,
    active: true
  },

  # Fuel Level – warning
  {
    metric: 'fuel_level',
    operator: '<',
    threshold: 10,
    severity: 'warning',
    car_scope: 1,
    active: true
  },

  # RPM – critical
  {
    metric: 'rpm',
    operator: '>',
    threshold: 14000,
    severity: 'critical',
    car_scope: 1,
    active: true
  }
])

puts "Rules seeded for Max Verstappen: #{Rule.count}"
