class RulesController < ActionController::API
  def index
    rules = Rule.all
    render json: rules.as_json(only: [:id, :metric, :operator, :threshold, :severity, :car_scope, :active])
  end

  def create
    rule = Rule.create!(rule_params)
    render json: rule, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def rule_params
    params.permit(:metric, :operator, :threshold, :severity, :car_scope, :active)
  end
end
