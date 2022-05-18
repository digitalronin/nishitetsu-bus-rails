# frozen_string_literal: true

class BusStop < ApplicationRecord
  scope :within_box, lambda { |min_lat:, max_lat:, min_lon:, max_lon:|
    where('(latitude between ? AND ?) AND (longitude between ? AND ?)', min_lat, max_lat, min_lon, max_lon)
      .limit(50)
  }

  has_many :route_stops
  has_many :bus_routes, through: :route_stops

  def api_id
    [jigyosha_cd, tei_cd].join(',')
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
    I18n.locale == :ja ? tei_name : tei_kana.romaji.capitalize.gsub('(', ' (')
  end
end
