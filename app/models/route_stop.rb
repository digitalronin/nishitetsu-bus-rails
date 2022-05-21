# frozen_string_literal: true

# == Schema Information
#
# Table name: route_stops
#
#  id           :bigint           not null, primary key
#  bus_stop_id  :bigint           not null
#  bus_route_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class RouteStop < ApplicationRecord
  belongs_to :bus_stop
  belongs_to :bus_route
end
