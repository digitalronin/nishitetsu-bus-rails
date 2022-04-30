class BusStop < ApplicationRecord
  scope :within_box, ->(min_lat:, max_lat:, min_lon:, max_lon:) {
    where('(latitude between ? AND ?) AND (longitude between ? AND ?)', min_lat, max_lat, min_lon, max_lon)
      .limit(50)
  }

  def api_id
    [jigyosha_cd,tei_cd].join(",")
  end
end
