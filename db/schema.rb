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

ActiveRecord::Schema.define(version: 2021_03_10_134215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cvs_cities", force: :cascade do |t|
    t.boolean "availability"
    t.string "name"
    t.string "state"
    t.string "zip"
    t.string "latitude"
    t.string "longitude"
    t.datetime "last_updated"
    t.datetime "when_available"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "location_statuses", force: :cascade do |t|
    t.string "address"
    t.string "store_id"
    t.datetime "time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "store_number"
    t.boolean "slot_1"
    t.boolean "slot_2"
    t.string "status", default: "Not Checked"
    t.string "full_address"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "latitude"
    t.string "longitude"
    t.string "county"
    t.string "phone"
    t.datetime "last_updated"
    t.datetime "when_available"
    t.boolean "availability"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "store_url"
    t.boolean "is_rite_aid", default: false
    t.boolean "is_walgreens", default: false
    t.integer "store_availability_count", default: 0
    t.boolean "is_cvs", default: false
    t.index ["availability"], name: "index_locations_on_availability"
    t.index ["state"], name: "index_locations_on_state"
    t.index ["when_available"], name: "index_locations_on_when_available"
  end

  create_table "update_logs", force: :cascade do |t|
    t.string "task"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "ip"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "zipcode"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "walgreens_cities", force: :cascade do |t|
    t.boolean "availability"
    t.string "name"
    t.string "state"
    t.string "zip"
    t.string "latitude"
    t.string "longitude"
    t.datetime "last_updated"
    t.datetime "when_available"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "zipcodes", force: :cascade do |t|
    t.integer "zipcode"
    t.string "city"
    t.string "state"
    t.string "latitude"
    t.string "longitude"
    t.string "timezone"
    t.string "dst"
    t.string "geopoint1"
    t.string "geopoint2"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
end
