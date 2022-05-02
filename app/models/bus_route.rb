class BusRoute < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :route_stops
  has_many :bus_stops, through: :route_stops
end
