# frozen_string_literal: true

json.extract!(
  bus_stop, :id, :upd_date, :jigyosha_name, :tei_kana, :ud_type, :city_name, :tei_cd, :jigyosha_cd,
  :tei_name, :tei_name_foreign, :tei_type, :city_cd, :area_type, :latitude, :longitude, :noriba_cd,
  :community_type, :navi_type, :created_at, :updated_at
)
json.url bus_stop_url(bus_stop, format: :json)
