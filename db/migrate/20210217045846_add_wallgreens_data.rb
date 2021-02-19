class AddWallgreensData < ActiveRecord::Migration[6.1]
  require 'csv'
  def change
    # For production, update Rite Aid records first
    puts "-- Updateing Rite Aid is_rite_aid boolean to be true for all records."
    locations = Location.all
    locations.each do |location|
      location.is_rite_aid = true
      location.save
    end
    # Now import Walgreens data
    puts "-- Adding Walgreens PA data"
    csv_text = File.read(Rails.root.join('db', 'locations_walgreens_pa.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
    csv.each do |row|
      t = Location.new
      t.store_number = row['store_number']
      t.full_address = row['full_address']
      t.address = row['address']
      t.city = row['city']
      t.state = row['state']
      t.zip = row['zip']
      t.latitude = row['latitude']
      t.longitude = row['longitude']
      t.phone = row['phone']
      t.county = row['county']
      t.is_walgreens = true
      t.store_url = row['store_url']
      t.save
      puts "#{t.store_number}, #{t.address} saved"
    end

    puts "-- Added Walgreens PA data. There are now #{Location.count} rows in the transactions table"
  end
end
