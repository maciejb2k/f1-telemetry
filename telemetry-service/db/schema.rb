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

ActiveRecord::Schema[7.2].define(version: 2025_04_27_054700) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "cars", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "car_code", null: false
    t.string "driver"
    t.string "chassis", default: "RB21"
    t.string "team_name"
    t.string "driver_photo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_code"], name: "index_cars_on_car_code", unique: true
  end

  create_table "readings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "car_id", null: false
    t.string "metric", null: false
    t.decimal "value", null: false
    t.string "session"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_readings_on_car_id"
    t.index ["metric", "value"], name: "index_readings_on_metric_and_value"
  end

  add_foreign_key "readings", "cars"
end
