class AddZipCodes < ActiveRecord::Migration[6.1]
  require 'csv'
  def change
    # Now import Walgreens data
    puts "-- Adding zipcodes"
    csv_text = File.read(Rails.root.join('db', 'zipcodes.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
    csv.each do |row|
      t = Zipcode.new
      t.zipcode = row['zipcode']
      t.city = row['city']
      t.state = row['state']
      t.latitude = row['latitude']
      t.longitude = row['longitude']
      t.timezone = row['timezone']
      t.dst = row['dst']
      t.geopoint1 = row['geopoint1']
      t.geopoint2 = row['geopoint2']
      t.save
    end

    puts "-- Added Zipcode data. There are now #{Zipcode.count} rows in the zipcode table"
  end
end
