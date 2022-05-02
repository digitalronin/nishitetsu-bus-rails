class BusStop < ApplicationRecord
  scope :within_box, ->(min_lat:, max_lat:, min_lon:, max_lon:) {
    where('(latitude between ? AND ?) AND (longitude between ? AND ?)', min_lat, max_lat, min_lon, max_lon)
      .limit(50)
  }

  has_many :route_stops
  has_many :bus_routes, through: :route_stops

  def api_id
    [jigyosha_cd,tei_cd].join(",")
  end

  def connected_stops
    bus_routes.map { |route| route.bus_stops }.flatten.uniq
  end
end
