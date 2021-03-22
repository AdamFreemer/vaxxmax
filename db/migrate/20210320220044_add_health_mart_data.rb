class AddHealthMartData < ActiveRecord::Migration[6.1]
  def change
    puts "-- Adding Health Mart store data"
    csv_text = File.read(Rails.root.join('db', 'locations_healthmart.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
    csv.each do |row|
      loc = Location.create(
        store_number: row['store_number'],
        name: row['name'],
        latitude: row['latitude'],
        longitude: row['longitude'],
        full_address: row['full_address'],
        address: row['address'],
        city: row['city'],
        state: row['state'],
        zip: row['zipcode'],
        county: row['county'],
        phone: row['phone'],
        is_health_mart: true
      )

      loc.save
      puts "#{loc.store_number}, #{loc.address} saved"
    end

    puts "-- Added Health Mart data. There are now #{Location.where(is_health_mart: true).count} Health Mart stores in the table"
    puts "-- There are now #{Location.count} rows in the transactions table"
  end
end
