class CreateWalgreensCities < ActiveRecord::Migration[6.1]
  def change
    create_table :walgreens_cities do |t|
      t.boolean :availability
      t.string :name
      t.string :state
      t.string :zip
      t.string :latitude
      t.string :longitude
      t.datetime :last_updated
      t.datetime :when_available

      t.timestamps
    end

    walgreens_locations = Location.where(is_walgreens: true).distinct.pluck(:city, :state)
    walgreens_locations.each do |walgreens_location|
      location = Location.where(
        is_walgreens: true, city: walgreens_location[0],
        state: walgreens_location[1]
      ).pluck(:city, :state, :zip, :latitude, :longitude).first

      walgreen_city = WalgreensCity.new(
        name: location[0],
        state: location[1],
        zip: location[2],
        latitude: location[3],
        longitude: location[4]
      )
      walgreen_city.save
      puts "-- WalgreenCity created: #{walgreen_city.name}"
    end
  end
end
