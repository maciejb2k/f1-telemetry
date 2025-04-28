class RulesController < ActionController::API
  before_action :set_rule, only: [:show, :update, :destroy]

  # GET /rules
  def index
    rules = Rule.all
    render json: rules.as_json(only: [:id, :metric, :operator, :threshold, :severity, :car_scope, :active])
  end

  # GET /rules/:id
  def show
    render json: @rule.as_json(only: [:id, :metric, :operator, :threshold, :severity, :car_scope, :active])
  end

  # POST /rules
  def create
    rule = Rule.create!(rule_params)
    render json: rule, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # PUT/PATCH /rules/:id
  def update
    if @rule.update(rule_params)
      render json: @rule
    else
      render json: { error: @rule.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /rules/:id
  def destroy
    @rule.destroy
    head :no_content
  end

  private

    def set_rule
      @rule = Rule.find(params[:id])
    end

    def rule_params
      params.permit(:metric, :operator, :threshold, :severity, :car_scope, :active)
    end
end
