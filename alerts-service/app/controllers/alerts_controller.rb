class AlertsController < ActionController::API
  before_action :set_alert, only: [:show]

  # GET /alerts?car_code=1&status=closed&since=...
  def index
    alerts = filtered_alerts(Alert.all)
    render json: alerts
  end

  # GET /alerts/:id
  def show
    render json: @alert
  end

  private

    def set_alert
      @alert = Alert.find(params[:id])
    end

    def filtered_alerts(scope)
      scope = scope.where(car_code: params[:car_code]) if params[:car_code].present?

      if params[:status].present?
        case params[:status]
        when 'active'
          scope = scope.active.order(opened_at: :asc)
        when 'closed'
          scope = scope.closed.order(opened_at: :desc)
        end
      end

      if params[:since].present?
        since_time = Time.parse(params[:since]) rescue 24.hours.ago
        scope = scope.where('opened_at >= ?', since_time)
      end

      if params[:limit].present?
        limit = params[:limit].to_i
        scope = scope.limit(limit)
      end

      scope
    end
end
