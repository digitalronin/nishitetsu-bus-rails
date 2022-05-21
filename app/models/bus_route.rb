# frozen_string_literal: true

# == Schema Information
#
# Table name: bus_routes
#
#  id           :bigint           not null, primary key
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  bus_stop_ids :text             default("")
#
class BusRoute < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def self.all_including_bus_stop(bus_stop_id)
    BusRoute.all.filter do |r|
      r.bus_stop_ids_array.include?(bus_stop_id)
    end
  end

  def add_bus_stop(bus_stop_id)
    ids = bus_stop_ids_array.push(bus_stop_id).uniq
    self.bus_stop_ids = ids.join(",")
    save
  end

  def bus_stops
    BusStop.find bus_stop_ids_array
  end

  def bus_stop_ids_array
    bus_stop_ids.split(",").map(&:to_i)
  end
end
