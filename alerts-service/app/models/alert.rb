# == Schema Information
#
# Table name: alerts
#
#  id              :uuid             not null, primary key
#  car_code        :integer          not null
#  closed_at       :datetime
#  last_trigger_at :datetime         not null
#  last_value      :decimal(, )      not null
#  metric          :string           not null
#  opened_at       :datetime         not null
#  operator        :string           not null
#  severity        :string           not null
#  threshold       :decimal(, )      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  rule_id         :uuid             not null
#
# Indexes
#
#  index_alerts_on_closed_at                           (closed_at)
#  index_alerts_on_rule_id_and_car_code_and_opened_at  (rule_id,car_code,opened_at)
#
class Alert < ApplicationRecord
  scope :active, -> { where(closed_at: nil) }
  scope :closed, -> { where.not(closed_at: nil) }

  def close!(time = Time.current)
    update!(closed_at: time)
  end
end
