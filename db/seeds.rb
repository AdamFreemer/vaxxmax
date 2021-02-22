# frozen_string_literal: true
require 'csv'
puts "-- Loading Rite Aid Stores --"
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
puts "-- Populating Rite Aid Completed --"
puts "-- Loading RiteAid town locations --"
puts "-- Completed loading RiteAid town locations --"
puts "-- There are now #{Location.where(is_rite_aid: true).count} Rite Aid stores loaded. --"
puts "-- There are  #{Location.where(is_walgreens: true).count} Walgreens stores loaded. --"
puts "-- There are  #{WalgreensCity.count} Walgreens town locations loaded. --"
puts "-- There are #{Location.count} total locations loaded. --"
