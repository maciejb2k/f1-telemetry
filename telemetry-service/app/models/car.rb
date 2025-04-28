# == Schema Information
#
# Table name: cars
#
#  id               :uuid             not null, primary key
#  car_code         :integer          not null
#  chassis          :string           default("RB21")
#  driver           :string
#  driver_photo_url :string
#  team_name        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_cars_on_car_code  (car_code) UNIQUE
#
class Car < ApplicationRecord
  has_many :readings, dependent: :destroy

  validates :car_code, presence: true, uniqueness: true
  validates :driver, presence: true
end
