#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to load bus route data from data/bus-data.json into the Rails database
#
#     rails g scaffold BusRoute name:string
#     rails g model RouteStop bus_stop:references bus_route:references
#     rails db:migrate
#     rails runner data/create_bus_routes.rb

require "json"

data = JSON.parse(File.read("data/bus-data.json"))

data["routes"].each do |name, bus_stops|
  route = BusRoute.find_by_name(name)
  puts "Route: #{name}"
  bus_stops.each do |tei_cd|
    if (bus_stop = BusStop.find_by_tei_cd(tei_cd))
      route.add_bus_stop(bus_stop.id)
      bus_stop.add_bus_route(route.id)
    end
  end
end
