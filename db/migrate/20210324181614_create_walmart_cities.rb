class CreateWalmartCities < ActiveRecord::Migration[6.1]
  def change
    create_table :walmart_cities do |t|
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

    walmart_locations = Location.where(is_walmart: true).distinct.pluck(:city, :state)
    walmart_locations.each do |walmart_location|
      location = Location.where(
        is_walmart: true,
        city: walmart_location[0],
        state: walmart_location[1]
      ).pluck(:city, :state, :zip, :county, :latitude, :longitude).first

      walmart_city = WalmartCity.new(
        city: location[0],
        state: location[1],
        zip: location[2],
        county: location[3],
        latitude: location[4],
        longitude: location[5]
      )
      walmart_city.save
      puts "-- WalmartCity created: #{walmart_city.city}"
    end
  end
end
