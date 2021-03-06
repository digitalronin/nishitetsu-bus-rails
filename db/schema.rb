# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_05_21_030629) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bus_routes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "bus_stop_ids", default: ""
  end

  create_table "bus_stops", force: :cascade do |t|
    t.string "upd_date"
    t.string "jigyosha_name"
    t.string "tei_kana"
    t.string "ud_type"
    t.string "city_name"
    t.string "tei_cd"
    t.string "jigyosha_cd"
    t.string "tei_name"
    t.string "tei_name_foreign"
    t.string "tei_type"
    t.string "city_cd"
    t.string "area_type"
    t.float "latitude"
    t.float "longitude"
    t.string "noriba_cd"
    t.string "community_type"
    t.string "navi_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "bus_route_ids", default: ""
  end

end
