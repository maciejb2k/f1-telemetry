Reading.delete_all
Car.delete_all

drivers = [
  { car_code: 1, driver: "Max Verstappen", chassis: "RB21", team_name: "Red Bull Racing", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/verstappen.jpg" },
  { car_code: 11, driver: "Sergio Perez", chassis: "RB21", team_name: "Red Bull Racing", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/perez.jpg" },
  { car_code: 16, driver: "Charles Leclerc", chassis: "SF-24", team_name: "Ferrari", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/leclerc.jpg" },
  { car_code: 55, driver: "Carlos Sainz", chassis: "SF-24", team_name: "Ferrari", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/sainz.jpg" },
  { car_code: 44, driver: "Lewis Hamilton", chassis: "W15", team_name: "Mercedes", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/hamilton.jpg" },
  { car_code: 63, driver: "George Russell", chassis: "W15", team_name: "Mercedes", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/russell.jpg" },
  { car_code: 4, driver: "Lando Norris", chassis: "MCL38", team_name: "McLaren", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/norris.jpg" },
  { car_code: 81, driver: "Oscar Piastri", chassis: "MCL38", team_name: "McLaren", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/piastri.jpg" },
  { car_code: 14, driver: "Fernando Alonso", chassis: "AMR24", team_name: "Aston Martin", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/alonso.jpg" },
  { car_code: 18, driver: "Lance Stroll", chassis: "AMR24", team_name: "Aston Martin", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/stroll.jpg" },
  { car_code: 10, driver: "Pierre Gasly", chassis: "A524", team_name: "Alpine", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/gasly.jpg" },
  { car_code: 31, driver: "Esteban Ocon", chassis: "A524", team_name: "Alpine", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/ocon.jpg" },
  { car_code: 23, driver: "Alexander Albon", chassis: "FW46", team_name: "Williams", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/albon.jpg" },
  { car_code: 2, driver: "Logan Sargeant", chassis: "FW46", team_name: "Williams", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/sargeant.jpg" },
  { car_code: 20, driver: "Kevin Magnussen", chassis: "VF-24", team_name: "Haas", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/magnussen.jpg" },
  { car_code: 27, driver: "Nico Hülkenberg", chassis: "VF-24", team_name: "Haas", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/hulkenberg.jpg" },
  { car_code: 22, driver: "Yuki Tsunoda", chassis: "VCARB 01", team_name: "Visa Cash App RB", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/tsunoda.jpg" },
  { car_code: 3, driver: "Daniel Ricciardo", chassis: "VCARB 01", team_name: "Visa Cash App RB", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/ricciardo.jpg" },
  { car_code: 77, driver: "Valtteri Bottas", chassis: "C44", team_name: "Stake F1 Team Kick Sauber", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/bottas.jpg" },
  { car_code: 24, driver: "Zhou Guanyu", chassis: "C44", team_name: "Stake F1 Team Kick Sauber", driver_photo_url: "https://media.formula1.com/content/dam/fom-website/drivers/2024Drivers/zhou.jpg" }
]

cars = drivers.map do |driver_data|
  Car.find_or_create_by!(
    car_code: driver_data[:car_code],
    driver: driver_data[:driver],
    chassis: driver_data[:chassis],
    team_name: driver_data[:team_name],
    driver_photo_url: driver_data[:driver_photo_url]
  )
end

sample_readings = [
  { metric: "tire_temp_fl", value: 50.0 },
  { metric: "tire_temp_fr", value: 50.0 },
  { metric: "tire_temp_rl", value: 50.0 },
  { metric: "tire_temp_rr", value: 50.0 },
  { metric: "brake_temp_fl", value: 100.0 },
  { metric: "brake_temp_fr", value: 100.0 },
  { metric: "brake_temp_rl", value: 100.0 },
  { metric: "brake_temp_rr", value: 100.0 },
  { metric: "engine_temp", value: 60.0 },
  { metric: "oil_temp", value: 60.0 },
  { metric: "fuel_level", value: 0.0 },
  { metric: "gear", value: 1 },
  { metric: "rpm", value: 0 },
  { metric: "speed", value: 0.0 },
  { metric: "throttle", value: 0.0 },
  { metric: "brake_pressure", value: 0.0 },
  { metric: "g_force_lat", value: 0.0 },
  { metric: "g_force_long", value: 0.0 },
  { metric: "battery_voltage", value: 11.0 },
  { metric: "drs_status", value: 0 },
  { metric: "ers_deployment", value: 0.0 },
  { metric: "ers_charge", value: 0.0 }
]

cars.each do |car|
  sample_readings.each do |reading_data|
    car.readings.create!(metric: reading_data[:metric], value: reading_data[:value])
  end
end
