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

ActiveRecord::Schema.define(version: 2021_04_13_004314) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cvs_cities", force: :cascade do |t|
    t.boolean "availability"
    t.string "name"
    t.string "state"
    t.string "zip"
    t.string "county"
    t.string "latitude"
    t.string "longitude"
    t.datetime "last_updated"
    t.datetime "when_available"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "appointments"
    t.integer "appointments_all"
  end

  create_table "health_mart_cities", force: :cascade do |t|
    t.boolean "availability"
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "county"
    t.string "latitude"
    t.string "longitude"
    t.datetime "last_updated"
    t.datetime "when_available"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "appointments"
    t.integer "appointments_all"
  end

  create_table "histories", force: :cascade do |t|
    t.integer "location_id"
    t.boolean "status"
    t.boolean "is_cvs"
    t.boolean "is_health_mart"
    t.boolean "is_rite_aid"
    t.boolean "is_walgreens"
    t.boolean "is_walmart"
    t.string "latitude"
    t.string "longitude"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "county"
    t.datetime "last_updated"
    t.datetime "when_available"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "vaccine_types"
    t.index ["created_at"], name: "index_histories_on_created_at"
    t.index ["is_cvs"], name: "index_histories_on_is_cvs"
    t.index ["is_health_mart"], name: "index_histories_on_is_health_mart"
    t.index ["is_rite_aid"], name: "index_histories_on_is_rite_aid"
    t.index ["is_walgreens"], name: "index_histories_on_is_walgreens"
    t.index ["is_walmart"], name: "index_histories_on_is_walmart"
    t.index ["state"], name: "index_histories_on_state"
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
    t.boolean "is_cvs"
    t.boolean "is_health_mart"
    t.string "name"
    t.boolean "is_walmart"
    t.integer "appointments"
    t.integer "appointments_all"
    t.string "vaccine_types"
    t.index ["availability"], name: "index_locations_on_availability"
    t.index ["is_cvs"], name: "index_locations_on_is_cvs"
    t.index ["is_health_mart"], name: "index_locations_on_is_health_mart"
    t.index ["is_rite_aid"], name: "index_locations_on_is_rite_aid"
    t.index ["is_walgreens"], name: "index_locations_on_is_walgreens"
    t.index ["is_walmart"], name: "index_locations_on_is_walmart"
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
    t.integer "appointments"
    t.integer "appointments_all"
    t.string "vaccine_types"
  end

  create_table "walmart_cities", force: :cascade do |t|
    t.boolean "availability"
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "county"
    t.string "latitude"
    t.string "longitude"
    t.datetime "last_updated"
    t.datetime "when_available"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "appointments"
    t.integer "appointments_all"
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


  create_view "all_providers", sql_definition: <<-SQL
      SELECT locations.address,
      locations.city,
      locations.state,
      locations.zip,
      locations.latitude,
      locations.longitude,
      locations.last_updated,
      locations.when_available,
      'Rite Aid'::text AS provider,
      '-'::character varying AS vaccine_types
     FROM locations
    WHERE ((locations.is_rite_aid = true) AND (locations.availability = true))
  UNION ALL
   SELECT locations.address,
      locations.city,
      locations.state,
      locations.zip,
      locations.latitude,
      locations.longitude,
      locations.last_updated,
      locations.when_available,
      'Walmart'::text AS provider,
      locations.vaccine_types
     FROM locations
    WHERE ((locations.is_walmart = true) AND (locations.availability = true))
  UNION ALL
   SELECT '-'::character varying AS address,
      cvs_cities.name AS city,
      cvs_cities.state,
      cvs_cities.zip,
      cvs_cities.latitude,
      cvs_cities.longitude,
      cvs_cities.last_updated,
      cvs_cities.when_available,
      'CVS'::text AS provider,
      '-'::character varying AS vaccine_types
     FROM cvs_cities
    WHERE (cvs_cities.availability = true)
  UNION ALL
   SELECT '-'::character varying AS address,
      health_mart_cities.name AS city,
      health_mart_cities.state,
      health_mart_cities.zip,
      health_mart_cities.latitude,
      health_mart_cities.longitude,
      health_mart_cities.last_updated,
      health_mart_cities.when_available,
      'Health Mart'::text AS provider,
      '-'::character varying AS vaccine_types
     FROM health_mart_cities
    WHERE (health_mart_cities.availability = true)
  UNION ALL
   SELECT '-'::character varying AS address,
      walgreens_cities.name AS city,
      walgreens_cities.state,
      walgreens_cities.zip,
      walgreens_cities.latitude,
      walgreens_cities.longitude,
      walgreens_cities.last_updated,
      walgreens_cities.when_available,
      'Walgreens'::text AS provider,
      walgreens_cities.vaccine_types
     FROM walgreens_cities
    WHERE (walgreens_cities.availability = true);
  SQL
end
