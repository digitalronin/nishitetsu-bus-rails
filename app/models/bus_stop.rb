# frozen_string_literal: true

# == Schema Information
#
# Table name: bus_stops
#
#  id               :bigint           not null, primary key
#  upd_date         :string
#  jigyosha_name    :string
#  tei_kana         :string
#  ud_type          :string
#  city_name        :string
#  tei_cd           :string
#  jigyosha_cd      :string
#  tei_name         :string
#  tei_name_foreign :string
#  tei_type         :string
#  city_cd          :string
#  area_type        :string
#  latitude         :float
#  longitude        :float
#  noriba_cd        :string
#  community_type   :string
#  navi_type        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bus_route_ids    :text             default("")
#
class BusStop < ApplicationRecord
  scope :within_box, lambda { |min_lat:, max_lat:, min_lon:, max_lon:|
    where("(latitude between ? AND ?) AND (longitude between ? AND ?)", min_lat, max_lat, min_lon, max_lon)
      .limit(50)
  }

  def api_id
    [jigyosha_cd, tei_cd].join(",")
  end

  def connected_stops
    bus_routes.map(&:bus_stops).flatten.uniq
  end

  def route_numbers
    bus_routes.map(&:name).sort
  end

  def as_json(options = {})
    super(options).merge(
      display_name:,
      routes: route_numbers
    )
  end

  def display_name
    I18n.locale == :ja ? tei_name : tei_kana.romaji.capitalize.gsub("(", " (")
  end

  def add_bus_route(bus_route_id)
    ids = bus_route_ids_array.push(bus_route_id).uniq
    self.bus_route_ids = ids.join(",")
    save
  end

  def bus_routes
    BusRoute.find bus_route_ids_array
  end

  def bus_route_ids_array
    bus_route_ids.split(",").map(&:to_i)
  end
end
