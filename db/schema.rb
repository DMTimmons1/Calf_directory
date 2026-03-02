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

ActiveRecord::Schema[7.1].define(version: 2026_03_01_215136) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calf_events", force: :cascade do |t|
    t.bigint "calf_id", null: false
    t.integer "event_type", default: 0, null: false
    t.text "description", null: false
    t.datetime "occurred_at", null: false
    t.integer "status_from"
    t.integer "status_to"
    t.decimal "weight_lbs", precision: 6, scale: 2
    t.string "medication_name"
    t.string "dose"
    t.string "route"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calf_id", "occurred_at"], name: "index_calf_events_on_calf_id_and_occurred_at"
    t.index ["calf_id"], name: "index_calf_events_on_calf_id"
    t.index ["event_type"], name: "index_calf_events_on_event_type"
  end

  create_table "calves", force: :cascade do |t|
    t.string "name", null: false
    t.date "birthdate"
    t.decimal "weight_lbs", precision: 6, scale: 2
    t.integer "status", default: 0, null: false
    t.text "medications"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_calves_on_name"
    t.index ["status"], name: "index_calves_on_status"
  end

  add_foreign_key "calf_events", "calves"
end
