class CreateBusStops < ActiveRecord::Migration[7.0]
  def change
    create_table :bus_stops do |t|
      t.string :upd_date
      t.string :jigyosha_name
      t.string :tei_kana
      t.string :ud_type
      t.string :city_name
      t.string :tei_cd
      t.string :jigyosha_cd
      t.string :tei_name
      t.string :tei_name_foreign
      t.string :tei_type
      t.string :city_cd
      t.string :area_type
      t.float :latitude
      t.float :longitude
      t.string :noriba_cd
      t.string :community_type
      t.string :navi_type

      t.timestamps
    end
  end
end
