class AlertsController < ActionController::API
  def active
    render json: Alert.active
  end

  def history
    since = params[:since] || 24.hours.ago
    render json: Alert.recent_closed_ordered(since)
  end

  def acknowledge
    alert = Alert.find(params[:id])
    alert.acknowledge!(params[:user_id])
    render json: { status: 'acknowledged' }
  end

  def snooze
    alert = Alert.find(params[:id])
    Rails.cache.write("alert:#{alert.id}:snoozed", true, expires_in: params[:duration_s].to_i.seconds)
    render json: { status: 'snoozed' }
  end
end
