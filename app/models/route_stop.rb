class RouteStop < ApplicationRecord
  belongs_to :bus_stop
  belongs_to :bus_route
end
