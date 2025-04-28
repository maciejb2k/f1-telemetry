# == Schema Information
#
# Table name: readings
#
#  id         :uuid             not null, primary key
#  metric     :string           not null
#  session    :string
#  value      :decimal(, )      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  car_id     :uuid             not null
#
# Indexes
#
#  index_readings_on_car_id            (car_id)
#  index_readings_on_metric_and_value  (metric,value)
#
# Foreign Keys
#
#  fk_rails_...  (car_id => cars.id)
#
class Reading < ApplicationRecord
  belongs_to :car

  VALID_METRICS = %w[
    tire_temp_fl tire_temp_fr tire_temp_rl tire_temp_rr
    brake_temp_fl brake_temp_fr brake_temp_rl brake_temp_rr
    engine_temp oil_temp fuel_level gear rpm speed throttle
    brake_pressure g_force_lat g_force_long battery_voltage
    drs_status ers_deployment ers_charge
  ].freeze

  VALID_SESSIONS = %w[
    FP1 FP2 FP3 Q1 Q2 Q3 SQ1 SQ2 SQ3 Sprint Grand_Prix
  ].freeze

  validates :metric, presence: true, inclusion: { in: VALID_METRICS }
  validates :value, numericality: true, presence: true
  validates :session, inclusion: { in: VALID_SESSIONS }, allow_nil: true
end
