# frozen_string_literal: true

# == Schema Information
#
# Table name: bus_routes
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BusRoute < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :route_stops
  has_many :bus_stops, through: :route_stops
end
