#!/usr/bin/env ruby

# Script to fetch, de-duplicate and collate Nishitetsu bus stop & route data.

require_relative "../app/services/nishitetsu"

# Parameters of geographic search area
MIN_LATITUDE = 33.34210577252230
MAX_LATITUDE = 33.88467831141420
MIN_LONGITUDE = 130.272245026617
MAX_LONGITUDE = 130.724079057735
STEP_SIZE = 0.01

# Where do we store the intermediate/final output data
DATADIR = "data"
BUS_STOPS_DATADIR = "#{DATADIR}/bus-stops"
BUS_NUMBERS_DATADIR = "#{DATADIR}/bus-numbers"
BUS_STOPS_FILE = "#{DATADIR}/fukuoka-bus-stops.json"

# The main file containing all the data we want
OUTPUT_FILE = "#{DATADIR}/bus-data.json"

def main
  check_or_create_data_directories
  fetch_all_bus_stops(BUS_STOPS_DATADIR)
  filter_and_dedupe_bus_stops(BUS_STOPS_DATADIR, BUS_STOPS_FILE)
  fetch_routes_for_each_stop(BUS_STOPS_FILE, BUS_NUMBERS_DATADIR)
  create_output_file(BUS_STOPS_FILE, BUS_NUMBERS_DATADIR, OUTPUT_FILE)
end

def check_or_create_data_directories
  [DATADIR, BUS_STOPS_DATADIR, BUS_NUMBERS_DATADIR].map do |path|
    unless FileTest.directory?(path)
      FileUtils.mkdir_p(path)
    end
  end
end

def fetch_all_bus_stops(datadir)
  (MIN_LONGITUDE..MAX_LONGITUDE).step(STEP_SIZE).each do |lon|
    (MIN_LATITUDE..MAX_LATITUDE).step(STEP_SIZE).each do |lat|
      fetch_and_store_bus_stops_near_point(
        lat: lat,
        lon: lon,
        datadir: datadir,
        area: STEP_SIZE
      )
    end
  end
end

def filter_and_dedupe_bus_stops(datadir, output_file)
  puts "Filter and de-duplicate bus stops..."

  list = []
  in_list = {}

  Dir["#{datadir}/*.json"].each do |file|
    data = JSON.parse(File.read(file))
    data["List"]
      .filter { |stop| stop["AREA_TYPE"] == "fukuoka" }
      .each do |stop|
        key = stop.hash
        if !in_list[key]
          list.push(stop)
          in_list[key] = true
        end
      end
  end

  File.write(output_file, list.to_json)
end

def fetch_routes_for_each_stop(bus_stops_file, datadir)
  JSON.parse(File.read(bus_stops_file)).each do |bus_stop|
    key = [bus_stop["JIGYOSHA_CD"], bus_stop["TEI_CD"]].join(",")
    filename = "#{datadir}/#{Digest::SHA256.hexdigest(key)}.json"

    if FileTest.exists?(filename)
      puts "Already fetched bus numbers for: #{key}"
    else
      puts "Fetching bus numbers for: #{key}"
      bus_stop["ROUTE_NUMBERS"] = Nishitetsu::Api.new.bus_routes_for_stop(key)
      File.write(filename, bus_stop.to_json)
      sleep 1
    end
  end
end

def create_output_file(bus_stops_file, bus_numbers_datadir, output_file)
  puts "Creating #{output_file}..."

  stops_with_routes = Dir["#{bus_numbers_datadir}/*.json"].each_with_object([]) do |file, list|
    data = JSON.parse(File.read(file))
    list.push(data) if data["ROUTE_NUMBERS"].any?
  end

  route_numbers = stops_with_routes.map { |b| b["ROUTE_NUMBERS"] }.flatten.uniq

  # A 'route' is an ordered list of TEI_CD identifiers
  routes = route_numbers.each_with_object({}) do |number, hash|
    hash[number] = stops_with_routes
      .filter { |b| b["ROUTE_NUMBERS"].include?(number) }
      .map { |b| b["TEI_CD"] }.sort
  end

  data = {"bus_stops" => stops_with_routes, "routes" => routes}

  File.write(output_file, data.to_json)
end

def fetch_and_store_bus_stops_near_point(lat:, lon:, datadir:, area:)
  key = [lat, lon].join(", ")
  filename = "#{datadir}/#{Digest::SHA256.hexdigest(key)}.json"
  if FileTest.exists?(filename)
    puts "Already fetched bus stops near: #{key}"
  else
    puts "Fetching bus stops near: #{key}"
    json = Nishitetsu::Api.new.bus_stops_near_location(lat: lat, lon: lon, area: area)
    File.write(filename, json)
    sleep 1
  end
end

main

# bin/create-stops-with-numbers-list.rb  # creates: data/fukuoka-bus-stops-with-routes.json
# bin/create-bus-data-file.rb  # creates: data/bus-data.json
