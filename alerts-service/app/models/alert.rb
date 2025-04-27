class Alert < ApplicationRecord
  scope :active, -> { where(closed_at: nil) }
  scope :closed, -> { where.not(closed_at: nil) }
  scope :acknowledged, -> { where(acknowledged: true) }
  scope :recent, ->(since) { where('opened_at >= ?', since) }
  scope :recent_closed_ordered, ->(since) {
    closed.where('opened_at >= ?', since).order(opened_at: :desc)
  }

  def open?
    closed_at.nil?
  end

  def close!(time = Time.current)
    update!(closed_at: time)
  end

  def acknowledge!(user_id, time = Time.current)
    update!(acknowledged: true, acknowledged_at: time, acknowledged_by: user_id)
  end
end
