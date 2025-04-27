puts "Kasowanie istniejących reguł..."
Rule.delete_all

puts "Dodawanie reguły: Temperatura opony FL > 110°C"
Rule.create!(
  metric: 'tire_temp_fl',
  operator: '>',
  threshold: 110,
  severity: 'warning',
  car_scope: 1,
  active: true
)

puts "Dodawanie reguły: Niski poziom ERS < 30%"
Rule.create!(
  metric: 'ers_charge',
  operator: '<',
  threshold: 30,
  severity: 'warning',
  car_scope: 1,
  active: true
)

puts "Dodano #{Rule.count} reguł."
