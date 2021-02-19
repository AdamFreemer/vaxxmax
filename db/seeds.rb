# frozen_string_literal: true
require 'csv'

csv_text = File.read(Rails.root.join('db', 'locations.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  t = Location.new
  t.is_rite_aid = true
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
  t.save
  puts "#{t.store_number}, #{t.address} saved"
end

puts "There are now #{Location.count} rows in the transactions table"