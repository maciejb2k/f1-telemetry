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

ActiveRecord::Schema[7.2].define(version: 2025_04_27_135825) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "alerts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "rule_id", null: false
    t.integer "car_code", null: false
    t.string "metric", null: false
    t.decimal "threshold", null: false
    t.string "operator", null: false
    t.decimal "last_value", null: false
    t.string "severity", null: false
    t.datetime "opened_at", null: false
    t.datetime "last_trigger_at", null: false
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["closed_at"], name: "index_alerts_on_closed_at"
    t.index ["rule_id", "car_code", "opened_at"], name: "index_alerts_on_rule_id_and_car_code_and_opened_at"
  end
end
