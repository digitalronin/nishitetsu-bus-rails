# frozen_string_literal: true

json.array! @bus_routes, partial: "bus_routes/bus_route", as: :bus_route
