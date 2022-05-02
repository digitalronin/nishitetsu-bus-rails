class CreateRouteStops < ActiveRecord::Migration[7.0]
  def change
    create_table :route_stops do |t|
      t.references :bus_stop, null: false, foreign_key: true
      t.references :bus_route, null: false, foreign_key: true

      t.timestamps
    end
  end
end
