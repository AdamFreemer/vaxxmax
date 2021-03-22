class CreateHealthMartCities < ActiveRecord::Migration[6.1]
  def change
    create_table :health_mart_cities do |t|
      t.boolean :availability
      t.string :name
      t.string :city
      t.string :state
      t.string :zip
      t.string :county
      t.string :latitude
      t.string :longitude
      t.datetime :last_updated
      t.datetime :when_available

      t.timestamps
    end

    health_mart_locations = Location.where(is_health_mart: true).distinct.pluck(:city, :state)
    health_mart_locations.each do |health_mart_location|
      location = Location.where(
        is_health_mart: true, city: health_mart_location[0],
        state: health_mart_location[1]
      ).pluck(:city, :state, :zip, :county, :latitude, :longitude).first

      health_mart_city = HealthMartCity.new(
        name: location[0],
        state: location[1],
        zip: location[2],
        county: location[3],
        latitude: location[4],
        longitude: location[5]
      )
      health_mart_city.save
      puts "-- HealthMartCity created: #{health_mart_city.name}"
    end
  end
end
