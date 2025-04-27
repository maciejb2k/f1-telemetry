class Rule < ApplicationRecord
  OPERATORS = %w[> >= < <= == !=].freeze

  validates :metric, :operator, :threshold, :severity, presence: true
  validates :operator, inclusion: { in: OPERATORS }
  validates :severity, inclusion: { in: %w[info warning critical] }

  scope :active, -> { where(active: true) }

  # Czy reguła dotyczy konkretnego auta, czy wszystkich
  def applies_to_car?(car_code)
    car_scope.nil? || car_scope == car_code
  end

  # Czy wartość telemetryczna spełnia warunek
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
