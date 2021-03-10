class CreateCvsCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cvs_cities do |t|
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

    cvs_locations = Location.where(is_cvs: true).distinct.pluck(:city, :state)
    cvs_locations.each do |cvs_location|
      location = Location.where(
        is_cvs: true, city: cvs_location[0],
        state: cvs_location[1]
      ).pluck(:city, :state, :zip, :latitude, :longitude).first

      cvs_city = CvsCity.new(
        name: location[0],
        state: location[1],
        zip: location[2],
        latitude: location[3],
        longitude: location[4]
      )
      cvs_city.save
      puts "-- CvsCity created: #{cvs_city.name}"
    end
  end
end
