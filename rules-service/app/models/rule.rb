# == Schema Information
#
# Table name: rules
#
#  id         :uuid             not null, primary key
#  active     :boolean          default(TRUE)
#  car_scope  :integer
#  metric     :string           not null
#  operator   :string           not null
#  severity   :string           not null
#  threshold  :decimal(, )      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rules_on_metric_and_car_scope  (metric,car_scope)
#
class Rule < ApplicationRecord
  OPERATORS = %w[> >= < <= == !=].freeze

  validates :metric, :operator, :threshold, :severity, presence: true
  validates :operator, inclusion: { in: OPERATORS }
  validates :severity, inclusion: { in: %w[info warning critical] }

  scope :active, -> { where(active: true) }

  def applies_to_car?(car_code)
    car_scope.nil? || car_scope == car_code
  end

  def condition_met?(value)
    value = value.to_f
    thr   = threshold.to_f
    case operator
    when '>'  then value > thr
    when '>=' then value >= thr
    when '<'  then value < thr
    when '<=' then value <= thr
    when '==' then value == thr
    when '!=' then value != thr
    else false
    end
  end
end
