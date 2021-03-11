class AddCvsData < ActiveRecord::Migration[6.1]
  require 'csv'
  def change
    puts "-- Adding CVS store data"
    csv_text = File.read(Rails.root.join('db', 'locations_cvs.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
    csv.each do |row|
      loc = Location.create(
        is_cvs: true,
        store_number: row['store_number'],
        full_address: row['full_address'],
        address: row['address'],
        city: row['city'],
        state: row['state'],
        zip: row['zip'],
        county: row['county'],
        latitude: row['latitude'],
        longitude: row['longitude'],
        phone: row['phone']
      )

      loc.save
      puts "#{loc.store_number}, #{loc.address} saved"
    end

    puts "-- Added CVS data. There are now #{Location.where(is_cvs: true).count} CVS stores in the table"
    puts "-- There are now #{Location.count} rows in the transactions table"
  end
end
