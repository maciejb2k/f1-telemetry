class Reading < ApplicationRecord
  belongs_to :car

  validates :metric, :value, presence: true
end
