class AddStopsToBusRoute < ActiveRecord::Migration[7.0]
  def change
    add_column :bus_routes, :bus_stop_ids, :text, default: ""
    add_column :bus_stops, :bus_route_ids, :text, default: ""
  end
end
