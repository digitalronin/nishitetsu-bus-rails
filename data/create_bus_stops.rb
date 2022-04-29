#!/usr/bin/env ruby

# Script to load data from data/bus-data.json into the Rails database
#
# Before running this script, generate scaffolds:
#
#     rails g scaffold BusStops upd_date:string jigyosha_name:string tei_kana:string ud_type:string city_name:string tei_cd:string jigyosha_cd:string tei_name:string tei_name_foreign:string tei_type:string city_cd:string area_type:string latitude:float longitude:float noriba_cd:string community_type:string navi_type:string
#
#     rails db:migrate
#
#     rails runner data/create_bus_stops.rb

require "json"

fields = [
      :jigyosha_name,
      :tei_kana,
      :ud_type,
      :city_name,
      :tei_cd,
      :jigyosha_cd,
      :tei_name,
      :tei_name_foreign,
      :tei_type,
      :city_cd,
      :area_type,
      :community_type,
      :navi_type,
]

data = JSON.parse(File.read("data/bus-data.json"))

data["bus_stops"].each do |bs|
  params = fields.reduce({}) { |hash, f| hash[f] = bs[f.to_s.upcase]; hash }
  params[:longitude] = bs["LONGITUDE"].to_f
  params[:latitude] = bs["LATITUDE"].to_f
  BusStop.create(params)
end
