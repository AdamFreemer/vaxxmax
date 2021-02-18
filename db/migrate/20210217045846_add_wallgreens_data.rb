class AddWallgreensData < ActiveRecord::Migration[6.1]
  require 'csv'
  def change
    csv_text = File.read(Rails.root.join('db', 'locations_walgreens_pa.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
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
      t.store_name = row['store_name']
      t.store_url = row['store_url']
      t.save
      puts "#{t.store_number}, #{t.address} saved"
    end

    puts "There are now #{Location.count} rows in the transactions table"
  end
end
