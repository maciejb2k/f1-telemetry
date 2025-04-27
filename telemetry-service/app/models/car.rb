class Car < ApplicationRecord
  has_many :readings, dependent: :destroy

  validates :car_code, presence: true, uniqueness: true
  validates :driver, presence: true
end
