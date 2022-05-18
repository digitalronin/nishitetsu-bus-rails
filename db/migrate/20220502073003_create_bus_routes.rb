# frozen_string_literal: true

class CreateBusRoutes < ActiveRecord::Migration[7.0]
  def change
    create_table :bus_routes do |t|
      t.string :name

      t.timestamps
    end
  end
end
