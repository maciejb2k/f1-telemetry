class Rule < ApplicationRecord
  OPERATORS = %w[> >= < <= == !=].freeze

  validates :metric, :operator, :threshold, :severity, presence: true

  def applies_to?(car_code, metric, value)
    return false unless active
    return false unless self.metric == metric
    return false unless car_scope.nil? || car_scope == car_code

    value = value.to_f
    threshold = self.threshold.to_f

    case operator
    when '>'  then value > threshold
    when '>=' then value >= threshold
    when '<'  then value < threshold
    when '<=' then value <= threshold
    when '==' then value == threshold
    when '!=' then value != threshold
    else false
    end
  end
end
